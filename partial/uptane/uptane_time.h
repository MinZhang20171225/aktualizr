#ifndef AKTUALIZR_PARTIAL_UPTANE_TIME_H_
#define AKTUALIZR_PARTIAL_UPTANE_TIME_H_

#include <stdint.h>
#include <stdbool.h>
typedef struct {
	uint16_t year;
	uint8_t month;
	uint8_t day;
	uint8_t hour;
	uint8_t minute;
	uint8_t second;
} uptane_time_t;

bool uptane_time_greater(uptane_time_t l, uptane_time_t r);

#endif /*AKTUALIZR_PARTIAL_UPTANE_TIME_H_*/
