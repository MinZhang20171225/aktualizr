#include "root.h"

struct root_ctx {
	/* Read/verify context */
	readjson_ctx_t* read_ctx;

	/* Inputs */
	uint32_t version_prev;
	uptane_time_t time;
	const uint8_t* old_hash;

	/* Outputs */
	role_keys_t* root_keys;
	role_keys_t* targets_keys;
	role_keys_t* time_keys;
	uint32_t* new_version;
};

bool root_init(root_ctx_t* ctx, uint32_t version_prev, uptane_time_t time,
	  const role_keys_t* root_keys, read_cb_t callbacks,
	  role_keys_t* new_root_keys, role_keys_t* new_targets_keys,
	  role_keys_t* new_time_keys, uint32_t* new_version, const uint8_t* old_hash,
	  uint8_t* new_hash) {

	ctx->version_prev = version_prev;
	ctx->time = time;
	ctx->old_hash = old_hash;

	ctx->root_keys = new_root_keys;
	ctx->targets_keys = new_targets_keys;
	ctx->time_keys = new_time_keys;
	ctx->new_version = new_version;

	ctx->read_ctx = readjson_ctx_new();
	if(!ctx->read_ctx)
		return false;

	return readjson_init(ctx->read_ctx, root_keys, &callbacks, new_hash);
}

root_result_t root_process(root_ctx_t* ctx) {
	crypto_key_t key_buf[CONFIG_UPTANE_ROOT_MAX_KEYS];
	uint8_t buf[CONFIG_UPTANE_STRING_BUF_SIZE];
	uptane_time_t time;
	int i;
	int nkeys;

	fixed_data(ctx->read_ctx, "{\"signatures\":");

	if(!read_signatures(&ctx->read_ctx))
		return ROOT_JSONERR;

	fixed_data(ctx->read_ctx, ",\"signed\":");

	/* signed section started, verification is performed in read_verify_wrapper */
	read_enter_signed(ctx->read_ctx);
	fixed_data(ctx->read_ctx, "{\"_type\":");

	if(!text_string(ctx->read_ctx, buf, CONFIG_UPTANE_STRING_BUF_SIZE))
		return ROOT_JSONERR;

	if(strcmp((const char*) buf, "Root"))
		return ROOT_WRONGTYPE;

	fixed_data(ctx->read_ctx, ",\"expires\":");

	if(!time_string(ctx, &time))
		return ROOT_JSONERR;

	if(uptane_time_greater(ctx->time, time))
		return ROOT_EXPIRED;

	fixed_data(ctx->read_ctx, ",\"keys\":{");

	i = 0;
	for(;;) {
		bool valid = false;

		if(i >= CONFIG_UPTANE_ROOT_MAX_KEYS)
			return ROOT_NOMEM;

		if(!hex_string(ctx->read_ctx, key_buf[i].keyid, CRYPTO_KEYID_LEN))
			return ROOT_JSONERR;
		fixed_data(ctx->read_ctx, ":{\"keytype\":");

		if(!text_string(ctx->read_ctx, buf, CONFIG_UPTANE_STRING_BUF_SIZE))
			return ROOT_JSONERR;

		key_buf[i].key_type = crypto_string_to_keytype((char*) buf); 
		if(key_buf[i].key_type != KEY_UNSUPP)
			valid = true;

		fixed_data(ctx->read_ctx, ",\"keyval\":{\"public\":");
		if(!hex_string(ctx->read_ctx, key_buf[i].keyval, CRYPTO_KEYVAL_LEN))
			return ROOT_JSONERR;

		if(valid)
			++i;
		fixed_data(ctx->read_ctx, "}}");

		one_char(ctx->read_ctx, buf);
		if(*buf == '}')
			break;
		else if(*buf != ',')
			return ROOT_JSONERR;
	}
	nkeys = i;
	fixed_data(ctx->read_ctx, ",\"roles\":{");

	for(;;) {
		role_keys_t* out_keys = NULL;

		if(!text_string(ctx->read_ctx, buf, CONFIG_UPTANE_STRING_BUF_SIZE))
			return ROOT_JSONERR;
		if(strcmp((const char*) buf, "root"))
			out_keys = ctx->root_keys;
		else if(strcmp((const char*) buf, "targets"))
			out_keys = ctx->targets_keys;
		if(strcmp((const char*) buf, "time"))
			out_keys = ctx->time_keys;
		fixed_data(ctx->read_ctx, ":{\"keyids\":[");
		if(!hex_string(ctx->read_ctx, buf, CRYPTO_KEYID_LEN))
			return ROOT_JSONERR;
		for(i = 0; i < nkeys; i++)
			if(!memcmp(buf, key_buf[i].keyid, CRYPTO_KEYID_LEN))
				memcpy(&out_keys->keys[out_keys->key_num++], &key_buf[i], sizeof(crypto_key_t));

		fixed_data(ctx->read_ctx, "],\"threshold\":");
		if(!integer_number(ctx->read_ctx, &out_keys->threshold))
			return ROOT_JSONERR;
		fixed_data(ctx->read_ctx, "}");
		if(*buf == '}')
			break;
		else if(*buf != ',')
			return ROOT_JSONERR;
	}
	fixed_data(ctx->read_ctx, ",\"version\":");
	if(!integer_number(ctx->read_ctx, ctx->new_version))
		return ROOT_JSONERR;
	if(*ctx->new_version < ctx->version_prev)
		return ROOT_DOWNGRADE;
	
	fixed_data(ctx->read_ctx, "}");

	/* signed section ended, verify */
	read_exit_signed(ctx->read_ctx);

	if(!read_verify_signed(ctx->read_ctx))
		return ROOT_SIGFAIL;
	
	/* trailing '}', EOF */
	fixed_data(ctx->read_ctx, "}");
	read_hash_finalize(ctx->read_ctx);

	if(ctx->old_hash && memcmp(ctx->read_ctx->hash_ctx.hash, ctx->old_hash, SHA512_HASH_SIZE))
		return ROOT_HASHFAIL;

	return ROOT_OK;
}

