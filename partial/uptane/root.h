#ifndef AKTUALIZR_PARTIAL_ROOT_H_
#define AKTUALIZR_PARTIAL_ROOT_H_

#include <stdint.h>
#include <stdbool.h>
#include "crypto.h"
#include "uptane_time.h"
#include "readjson.h"
#include "sha512.h"
typedef enum {
	ROOT_OK,		/* Valid root.json				   */
	ROOT_MISSINGROLE,	/* Dynamic memory error				   */
	ROOT_NOMEM,		/* Dynamic memory error				   */
	ROOT_SIGFAIL,		/* Signature verification failed		   */
	ROOT_HASHFAIL,		/* Old hash(if provided) doesn't match the new one */
	ROOT_JSONERR,		/* Malformed JSON				   */
	ROOT_WRONGTYPE,		/* _type field is not "Root"			   */
	ROOT_EXPIRED,		/* targets.json has expired			   */
	ROOT_DOWNGRADE		/* New version is lower that the previous one	   */
} root_result_t;

struct root_ctx;
typedef struct root_ctx root_ctx_t;

root_ctx_t* root_ctx_new(void);
void root_ctx_free(root_ctx_t* ctx);

/* Yes, a whole lot of parameters. As we don't want to store the whole root.json in memory,
 * but need to verify it twice, primary is asked to send the root.json twice. Fitst time 
 * the process should be initialized with old root keyset as "root_keys", and NULL old_hash.
 * Only if root_process returns success should we proceed to second run.
 * On the second run "root_keys" are set to "new_root_keys" from the previous run and
 * "old_hash" respectively to the returned "new_hash". We still need to provide a separate
 * buffer for new_hash, because there is no internal buffer in root_ctx_t.
 */
bool root_init(root_ctx_t* ctx, uint32_t version_prev, uptane_time_t time,
	       const role_keys_t* root_keys, read_cb_t callbacks,
	       role_keys_t* new_root_keys, role_keys_t* new_targets_keys,
	       role_keys_t* new_time_keys, uint32_t* new_version, const uint8_t* old_hash,
	       uint8_t* new_hash);

root_result_t root_process(root_ctx_t* ctx);

#endif //AKTUALIZR_PARTIAL_ROOT_H_

