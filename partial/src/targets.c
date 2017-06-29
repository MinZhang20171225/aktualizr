#include <stdarg.h>
#include "targets.h"
#include "crypto.h"
#include "uptane_config.h"
#include "sha512.h"
#include "gjson.h"


typedef enum {
	STATE_INIT,
	STATE_OBJECT,
	STATE_VALUE,
} targets_state_t;

typedef enum {
	KEY_SIGNATURES = 0,
	KEY_KEYID,
	KEY_METHOD,
	KEY_SIG,
	KEY_SIGNED,
	KEY_TYPE,
	KEY_EXPIRES,
	KEY_TARGETS,
	KEY_CUSTOM,
	KEY_ECU_IDENTIFIER,
	KEY_HARDWARE_IDENTIFIER,
	KEY_RELEASE_COUNTER,
	KEY_HASHES,
	KEY_SHA256,
	KEY_SHA512,
	KEY_LENGTH,
	KEY_VERSION,
	KEY_ANY,
	KEY_ARRAY,
	KEY_NUMBER, // dummy value to get the total number of possible keys
} targets_key_t;

// The order should be the same as in targets_key_t
static const char* targets_key_strings[] = {"signatures", "keyid", "method", "sig",
					    "signed", "_type", "expires", "targets",
					    "custom", "ecu_identifier", "hardware_identifier",
					    "release_counter", "hashes", "sha256", "sha512",
					    "length", "version", "*", "["};

struct targets_ctx {
	/* Inputs */
	int version_prev;
	uint32_t time;
	crypto_key_and_signature_t* sigs[CONFIG_UPTANE_TARGETS_MAX_SIGS]; 
	int num_keys;
	int threshold;
	uint8_t* ecu_id;
	uint8_t* hardware_id;

	/* Outputs */
	uint8_t sha512_hash[SHA512_HASH_SIZE]; /* Only one hash is currently supported*/
	int version;
	int length;
	targets_result_t res;

	/* Intermediate state */
	/* Intermediate state - Overall */
	gj_context_t* json_ctx;
	targets_state_t state;

	/* TODO: Consider merging boolean flags into bitmasks */
	bool version_checked;
	bool time_checked;
	bool signatures_checked;
	bool got_image;
	targets_key_t path[CONFIG_UPTANE_TARGETS_MAX_NESTEDNESS];
	int path_ind;

	/* Intermediate state - Signatures */
	bool got_sig_keyid;
	bool got_sig_method;
	bool got_sig_sig;
	bool sig_ignore;
	int current_sig;
	int sigs_found;
	bool sigvalid[CONFIG_UPTANE_TARGETS_MAX_SIGS];
	/* Intermediate state - Signed */
	bool ecuid_matches;
	bool hardwareid_matches;
	/* Intermediate state - Target */
	bool hash_found;
	bool length_found;
	/* Intermediate state - Signature check */
	crypto_verify_ctx_t* sig_ctxs[CONFIG_UPTANE_TARGETS_MAX_SIGS];
	bool in_signed;
};

#ifdef CONFIG_UPTANE_NOMALLOC
static targets_ctx_t targets_ctxs[CONFIG_UPTANE_TARGETS_NUM_CONTEXTS];
static bool targets_ctx_busy[CONFIG_UPTANE_TARGETS_NUM_CONTEXTS] = {0, }; //could be reduce to a bitmask when new/free performance is an issue
#endif

targets_ctx_t* targets_ctx_new() {
#ifdef CONFIG_UPTANE_NOMALLOC
	int i;

	for(i = 0; i < CONFIG_UPTANE_TARGETS_NUM_CONTEXTS; i++)
		if(!targets_ctx_busy[i])
			return &targets_ctxs[i];
	return NULL;
#else
	return malloc(sizeof(targets_ctx_t));

#endif
}

void targets_ctx_free(targets_ctx_t* ctx) {
	int i;
#ifdef CONFIG_UPTANE_NOMALLOC
	uintptr_t j = ((uintptr_t) ctx - (uintptr_t) targets_ctxs)/sizeof(targets_ctx_t); 
#endif

	gj_ctx_free(ctx->json_ctx);

	for(i = 0; i < ctx->num_keys; i++)
		if(ctx->sigvalid[i])
			crypto_verify_ctx_free(ctx->sig_ctxs[i]);

#ifdef CONFIG_UPTANE_NOMALLOC
	targets_ctx_busy[j] = 0;
#else
	free(ctx);
#endif
}

/* Compare two json "paths". Variadic part contains keys terminated with
 * KEY_NUMBER. E.g. path_equal(path. len, KEY_SIGNATURES, KEY_KEYID, KEY_NUMBER) */
static bool path_equal(const targets_key_t* path, int len, ...) {
	va_list args;
	va_start(args, len);
	targets_key_t key;
	int i;

	for(i = 0; i < len; i++) {
		key = va_arg(args, int);
		if(path[i] != key && key != KEY_ANY)
			return false;
	}

	return (va_arg(args, int) == KEY_NUMBER);
}

/* Process signatures.keyid field, updating the context */
static bool process_keyid(targets_ctx_t* ctx, const uint8_t* data) {
	size_t len;
	int i;
	uint8_t keyid[CRYPTO_KEYID_LEN];

	if(ctx->sig_ignore)
		return true;

	len = strnlen(data, 2*CRYPTO_KEYID_LEN);
	if(len != 2*CRYPTO_KEYID_LEN)
		return false;

	for(i = 0; i < CRYPTO_KEYID_LEN; i++)
		keyid[i] = hex(data[i << 1], data[1+ (i << i)]);

	ctx->sig_ignore = true;
	for(i = 0; i < ctx->num_keys; i++)
		if(!memcmp(ctx->sigs[i]->key->keyid, keyid, CRYPTO_KEYID_LEN)) {
			ctx->current_sig = i;
			ctx->sig_ignore = false;
			break;
		}
	ctx->got_sig_keyid = true;
	return true;
}

/* Process signatures.method field, updating the context */
static bool process_method(targets_ctx_t* ctx, const uint8_t* data) {
	ctx->sig_ignore = ctx->sig_ignore || crypto_keytype_supported(data);
	ctx->got_sig_method = true;
	return true;
}

/* Process signatures.sig field, updating the context */
static bool process_sig(targets_ctx_t* ctx, const uint8_t* data) {
	int len;
	int i;
	crypto_key_and_signature_t* s;

	if(ctx->sig_ignore)
		return true;

	/* current_sig is set when key_id is encountered, we depend on it */
	if(!ctx->got_sig_keyid)
		return false;

	len = strlen(data);
	if(len != 2*CRYPTO_SIGNATURE_LEN)
		return false;

	s = ctx->sigs[ctx->current_sig];
	for(i = 0; i < CRYPTO_SIGNATURE_LEN; i++)
		s->sig[i] = hex(data[i << 1], data[1+ (i << i)]);

	ctx->got_sig_sig = true;
	return true;
}

static targets_result_t checkresult(targets_ctx_t* ctx) {
	if(!ctx->version_checked)
		return TARGETS_NOVERSION;
	if(!ctx->time_checked)
		return TARGETS_NOTIME;
	if(!ctx->signatures_checked)
		return TARGETS_NOSIGS;
	if(ctx->sigs_found < ctx->threshold)
		return TARGETS_LOWSIGS;
	if(!ctx->got_image) {
		if(!ctx->hash_found)
			return TARGETS_NOHASH;
		if(!ctx->length_found)
			return TARGETS_NOLENGTH;
		return TARGETS_OK_NOIMAGE;
	}
	if(ctx->version == ctx->version_prev)
		return TARGETS_OK_NOUPDATE;
	return TARGETS_OK_UPDATE;
}

static bool targets_json_handler(gj_event_t ev, const uint8_t* data, void* priv) {
	targets_ctx_t* ctx = (targets_ctx_t*) priv;

	if(ev == GJ_EVENT_ERR) {
		ctx->res = TARGETS_JSONERR;
		return true;
	}

	if(ev == GJ_EVENT_CHAR) {
		if(ctx->in_signed) {
			int i;

			for(i = 0; i < ctx->num_keys; i++)
				if(ctx->sigvalid[i])
					crypto_verify_putc(ctx->sig_ctxs[i], *data);
		}
		return false;
	}

	/* Application logic */
	if(ev == GJ_EVENT_OBJBEGIN) {
		if(path_equal(ctx->path, ctx->path_ind, KEY_SIGNATURES, KEY_ARRAY, KEY_NUMBER)) {
			/* Entered signature object, initialize state */
			ctx->got_sig_keyid = false;
			ctx->got_sig_method = false;
			ctx->got_sig_sig = false;
			ctx->sig_ignore = false;
		}
		if(path_equal(ctx->path, ctx->path_ind, KEY_SIGNED, KEY_TARGETS, KEY_ANY, KEY_NUMBER)) {
			/* Entered target, initialize state */
			ctx->got_sig_keyid = false;
			ctx->ecuid_matches = false;
			ctx->hardwareid_matches = false;
		}

		if(path_equal(ctx->path, ctx->path_ind, KEY_SIGNED,  KEY_NUMBER)) {
			int i;
			/* Start verifying signatures */
			for(i = 0; i < ctx->num_keys; i++)
				if(ctx->sigvalid[i]) {
					crypto_verify_ctx_init(ctx->sig_ctxs[i]);
					crypto_verify_putc(ctx->sig_ctxs[i], '{');
				}
			ctx->in_signed = true;
		}
	}
	
	if(ev == GJ_EVENT_OBJEND) {
		if(path_equal(ctx->path, ctx->path_ind, KEY_SIGNATURES, KEY_ARRAY, KEY_NUMBER)) {
			/* Exited signature object, set signature validness */
			if(!ctx->sig_ignore && ctx->got_sig_keyid && ctx->got_sig_method &&
			    ctx->got_sig_sig) {
				ctx->sigvalid[ctx->current_sig] = true;
				ctx->sig_ctxs[ctx->current_sig] = crypto_verify_ctx_new();
				if(!ctx->sig_ctxs[ctx->current_sig]) {
					ctx->res = TARGETS_NOMEM;
					return true;
				}
				++ctx->sigs_found;
			}
		}
		if(path_equal(ctx->path, ctx->path_ind, KEY_SIGNED, KEY_TARGETS, KEY_ANY, KEY_NUMBER)) {
			if(ctx->ecuid_matches && ctx->hardwareid_matches) {
				if(ctx->got_image) {
					ctx->res = TARGETS_ECUDUPLICATE;
					return true;
				}
				ctx->got_image = true;
			}
		}

		if(path_equal(ctx->path, ctx->path_ind, KEY_SIGNED,  KEY_NUMBER)) {
			/* Start verifying signatures */
			bool valid = true;
			int i;
			/* trailing '}' has already been processed in GJ_EVENT_CHAR */
			for(i = 0; i < ctx->num_keys; i++)
				if(ctx->sigvalid[i])
					valid = valid && crypto_verify_result(ctx->sig_ctxs[i]);
			if(!valid) {
				ctx->res = TARGETS_VERIFICATION_FAILED;
				return true;
			}
			ctx->in_signed = false;
			ctx->signatures_checked = true;
		}

		// exiting top-level object, prepare result
		if(ctx->path_ind == 0) {
			ctx->res = checkresult(ctx);
			return true;
		}
	}

	if (ev >= GJ_EVENT_STRING && ev <= GJ_EVENT_NUMBER) {
		/* Only some of the path->value combinations are valid. If success was not
		 * set to true by some of the subsequent clauses, return JSON error */
		bool success = false;

		targets_key_t* path = ctx->path;
		int path_len = ctx->path_ind;


		if(path_equal(path, path_len, KEY_SIGNATURES, KEY_ARRAY, KEY_KEYID, KEY_NUMBER))
			success = process_keyid(ctx, data);


		if(path_equal(path, path_len, KEY_SIGNATURES, KEY_ARRAY, KEY_METHOD, KEY_NUMBER))
			success = process_method(ctx, data);

		if(path_equal(path, path_len, KEY_SIGNATURES, KEY_ARRAY, KEY_SIG, KEY_NUMBER))
			success = process_sig(ctx, data);

		if(path_equal(path, path_len, KEY_SIGNED, KEY_TYPE, KEY_NUMBER)) {
			if(strcmp(data, "Targets")) {
				ctx->res = TARGETS_WRONGTYPE;
				return true;
			}
			success = true;
		}
	
		if(path_equal(path, path_len, KEY_SIGNED, KEY_EXPIRES, KEY_NUMBER)) {
			if(get_time(data) <= ctx->time) {
				ctx->res = TARGETS_EXPIRED;
				return true;
			}
			ctx->time_checked = true;
			success = true;
		}

		if(path_equal(path, path_len, KEY_SIGNED, KEY_VERSION, KEY_NUMBER)) {
			ctx->version = get_num(data);
			if(ctx->version < ctx->version_prev) {
				ctx->res = TARGETS_DOWNGRADE;
				return true;
			}
			ctx->version_checked = true;
			success = true;
		}

		if(path_equal(path, path_len, KEY_SIGNED, KEY_ANY, KEY_CUSTOM, KEY_ECU_IDENTIFIER, KEY_NUMBER)) {
			if(!strcmp(ctx->ecu_id, data))
				ctx->ecuid_matches = true;
			success = true;
		}
		if(path_equal(path, path_len, KEY_SIGNED, KEY_ANY, KEY_CUSTOM, KEY_HARDWARE_IDENTIFIER, KEY_NUMBER)) {
			if(!strcmp(ctx->hardware_id, data))
				ctx->hardwareid_matches = true;
			success = true;
		}
		if(path_equal(path, path_len, KEY_SIGNED, KEY_ANY, KEY_HASHES, KEY_SHA512, KEY_NUMBER)) {
			if(ctx->ecuid_matches && ctx->hardwareid_matches) {
				int i;
				for(i = 0; i < SHA512_HASH_SIZE; i++)
					ctx->sha512_hash[i] = hex(data[i << 1], data[1+ (i << i)]);
				ctx->hash_found = true;
			}
			success = true;
		}
		if(path_equal(path, path_len, KEY_SIGNED, KEY_ANY, KEY_LENGTH, KEY_NUMBER)) {
			if(ctx->ecuid_matches && ctx->hardwareid_matches) {
				ctx->length = get_num(data);
				ctx->length_found = true;
			}
			success = true;
		}
		if(!success) {
			ctx->res = TARGETS_JSONERR;
			return true;
		}
	}

	/* Path logic */
	switch(ctx->state) {
		case STATE_INIT:
			if(ev == GJ_EVENT_OBJBEGIN) {
				ctx->state = STATE_OBJECT;
				return false;
			}
			break;
		case STATE_OBJECT:
			if(ev == GJ_EVENT_OBJEND) {
				if(!ctx->path_ind) {
					// we should not have got here, it is processed in app;ication logic
					ctx->res = TARGETS_INTERNAL_ERROR;
					return true;
				} else {
					--ctx->path_ind;
					if(ctx->path_ind && ctx->path[ctx->path_ind-1] == KEY_ARRAY) {
						ctx->state = STATE_VALUE;
					} // else state = STATE_OBJECT
					return false;
				}
			} else if (ev == GJ_EVENT_KEY){
				int i;
				for(i = 0; i < KEY_ANY; i++)
					if(!strcmp(data, targets_key_strings[i]))
						break;
				// path entry is set to KEY_ANY if string is not found
				ctx->path[ctx->path_ind++] = i;
				ctx->state = STATE_VALUE;
				return false;
			}
			break;
		case STATE_VALUE:
			if(ev == GJ_EVENT_OBJBEGIN) {
				ctx->state = STATE_OBJECT;
				return false;
			} else if(ev == GJ_EVENT_ARRBEGIN) {
				ctx->path[ctx->path_ind++] = KEY_ARRAY;
				return false;
			} else if(ev == GJ_EVENT_ARREND) {
				if(ctx->path[--ctx->path_ind] == KEY_ARRAY) {
					if(!ctx->path_ind || ctx->path[ctx->path_ind-1] != KEY_ARRAY) {
						ctx->state = STATE_OBJECT;
					} /* else state = STATE_VALUE */
					return false;
				}
			} else if (ev >= GJ_EVENT_STRING && ev <= GJ_EVENT_NUMBER) {
				if(ctx->path[ctx->path_ind-1] == KEY_ARRAY) {
					// just another value in array, value expected
					return false;
				} else if(ctx->path_ind == 1 || ctx->path[ctx->path_ind-2] != KEY_ARRAY) {
					// exited key:value pair, occured in an object
					ctx->path_ind--;
					ctx->state = STATE_OBJECT;
					return false;
				} else {
					// exited key:value pair, occured in an array
					ctx->path_ind--;
					return false;
				}
			}
	}
	/* We haven't returned successfully yet => JSON is broken*/
	ctx->res = TARGETS_JSONERR;
	return true;
}

void targets_init(targets_ctx_t* ctx, int version_prev, uint32_t time,
		  const crypto_key_t* keys, int key_num, int threshold) {
	int i;

	ctx->version_prev = version_prev;
	ctx->time = time;
	for (i = 0; i < key_num; i++) {
		if(i >= CONFIG_UPTANE_TARGETS_MAX_SIGS)
			break;
		ctx->sigs[i] = new_sig();
		ctx->sigs[i]->key = &keys[i];
		ctx->sigvalid[i] = false;
	}
	ctx->num_keys = i;
	ctx->sigs_found = 0;

	ctx->threshold = threshold;
	ctx->state = STATE_INIT;
	ctx->json_ctx = gj_ctx_new();
	gj_init(ctx->json_ctx, targets_json_handler, ctx);

	ctx->version_checked = ctx->time_checked = ctx->signatures_checked = false;
	ctx->path_ind = 0;
			
	ctx->hash_found = false;
	ctx->length_found = false;

	ctx->in_signed = false;
}


bool targets_process(targets_ctx_t* ctx, const uint8_t* data, size_t len) {
	return gj_process(ctx->json_ctx, data, len);
}

targets_result_t targets_get_result(const targets_ctx_t* ctx, uint8_t* sha512_hash, int* length, int* version) {
	memcpy(sha512_hash, ctx->sha512_hash, SHA512_HASH_SIZE);
	*version = ctx->version;
	*length = ctx->length;
	return ctx->res;
}

