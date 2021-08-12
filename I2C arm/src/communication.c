/* Communcations with all peripheral devices.
 * Written in C to take advantage of structs.
 * 
 */
 
#include "lpc24xx.h"
#include "peripheral.h"

#define B(n) (1<<(n))

extern char read_i2c(char addr, char data);
extern void record_meas(char data, char len); 
// Expects i2c to be already setup with EN
void record_data(void){
	// For each of the peripherals, in the order they appear in the list, 
	peripheral_t prphls[N_PRPHLS] = ALL_PRPHLS;
	
	for (int i = 0; i < N_PRPHLS; i++){
		int j = 0; // external scope
		// obtain data in batches of 8
		for (;prphls[i].bit_len > 8; prphls[i].bit_len -= 8){
			char meas = read_i2c(prphls[i].slave_addr, prphls[i].req_data[j]);
			record_meas(meas, 8);
			j++;
		}
		// obtain remaining data
		// remaining bit length is given by prphls[i].bit_len
		char meas = read_i2c(prphls[i].slave_addr, prphls[i].req_data[j]);
		record_meas(meas, prphls[i].bit_len); 
		
		// Finished transmission, set stop bit to release slave
		I20CONSET = B(4);
		I20CONCLR = B(3);
		while(!(I20CONSET & B(4)));
		// Stop bit is reset automatically once it is sent.
	}
}
