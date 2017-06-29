#ifndef AKTUALIZR_PARTIAL_TARGETS_H_
#define AKTUALIZR_PARTIAL_TARGETS_H_

#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include "crypto.h"
typedef enum {
	TARGETS_OK_NOIMAGE,		// Valid targets.json, no image for this ECU
	TARGETS_OK_NOUPDATE,		// Valid targets.json, version is the same
	TARGETS_OK_UPDATE,		// Valid targets.json, new image available
	TARGETS_NOMEM,			// Dynamic memory error
	TARGETS_INTERNAL_ERROR,		// Assertion failed, shouldn't get this normally
	TARGETS_ECUDUPLICATE,		// ECU is mentioned twice
	TARGETS_NOHASH,			// No suitable hash found
	TARGETS_NOLENGTH,		// Image length was not found
	TARGETS_VERIFICATION_FAILED,	// Signature verification failed
	TARGETS_JSONERR,		// Malformed JSON
	TARGETS_WRONGTYPE,		// _type field is not "Targets"
	TARGETS_EXPIRED,		// targets.json has expired
	TARGETS_DOWNGRADE,		// New version is lower that the previous one
	TARGETS_NOVERSION,		// No "version" field found
	TARGETS_NOTIME,			// No "expires" field found	
	TARGETS_NOSIGS,			// Signature check couldn't be performed
	TARGETS_LOWSIGS,		// Number of signatures is lower than threshold
} targets_result_t;

struct targets_ctx;
typedef struct targets_ctx targets_ctx_t;

void targets_init(targets_ctx_t* ctx, int version_prev, uint32_t time,
		  const crypto_key_t* keys, int key_num, int threshold);
bool targets_process(targets_ctx_t* ctx, const uint8_t* data, size_t len);
targets_result_t targets_get_result(const targets_ctx_t* ctx, uint8_t* sha512_hash, int* length, int* version);
#endif //AKTUALIZR_PARTIAL_TARGETS_H_
