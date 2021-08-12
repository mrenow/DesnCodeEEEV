#ifndef SETTINGS_H
#define SETTINGS_H



typedef struct peripheral{
	char bit_len;
	char slave_addr;
	char n_req;
	char *req_data;
} peripheral_t;

char MAX44009_data[2] = {0x03, 0x04};

#define MAX44009 	((peripheral_t){12, 0x94, 2, MAX44009_data})
//#define TMP117 		((peripheral_t){16, 0x90, })
//#define MMC3316xMT ((peripheral_t){48, 0x30}) 

#define N_PRPHLS 1
#define ALL_PRPHLS {MAX44009}

#define MEAS_PERIOD 120 // in seconds

#endif

