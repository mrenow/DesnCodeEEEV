#include "lpc24xx.h"
#include "peripheral.h"

#define B(n) (1<<(n))

void write_i2c(char addr, char data);
void read_i2c(char addr);
// Expects i2c to be already setup with EN
void record_data(void){
	// For each of the peripherals, in the order they appear in the list, 
	peripheral_t prphls[N_PRPHLS] = ALL_PRPHLS;
	
	for (int i = 0; i < N_PRPHLS; i++){
		int j = 0;
		for (;prphls[i].bit_len > 8; prphls[i].bit_len -= 8){
			write_i2c (prphls[i].slave_addr, prphls[i].req_data[j]);
			
			j++;
		}
		write_i2c(prphls[i].slave_addr, prphls[i].req_data[j]);
		// Finished transmission, set stop bit to release slave
		I20CONSET = B(4);
		// Stop bit is reset automatically once it is sent.
	}

	
	

}


void write_i2c(char addr, char data){
	// send slave address
	I20DAT = addr;
	while(!I21STAT & 1){
	
	}
	

}

void read_i2c(char addr){

}
