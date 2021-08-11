#ifndef SETTINGS_H
#define SETTINGS_H

typedef struct peripheral{
	char bitlen;
	char slaveAddr;
} peripheral_t;

#define MAX44009 	((peripheral_t){22, 0x94})
#define TMP117 		((peripheral_t){16, 0x90})
#define MMC3316xMT ((peripheral_t){48, 0x30}) 

#define N_PRPHLS 3
#define ALL_PRPHLS ((*peripheral_t){MAX44009, TMP117, MMC3316xMT})

#define MEAS_PERIOD 120 // in seconds

#endif

