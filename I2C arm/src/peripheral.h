#ifndef SETTINGS_H
#define SETTINGS_H

#define BMASK(start, end) ((0xFFFFFFFF>>(31-(end)+(start)))<<(start))
#define B(n) ((unsigned)(1<<n))
#define BIT_WRITE(reg, val, start, end) reg=(reg&~BMASK(start, end))|(((unsigned)val)<<start);

typedef struct peripheral{
	char bit_len;
	char slave_addr;
	char req_data[];
} peripheral_t;

extern char N_PRPHLS;
extern peripheral_t *ALL_PRPHLS;

#define MEAS_PERIOD 2 // in minutes

#endif

