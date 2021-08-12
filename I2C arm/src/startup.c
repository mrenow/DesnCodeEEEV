#include "lpc24xx.h"
#include "peripheral.h"
#include "communication.h"

#define BATRAM_BASE 0xE0084000

// Assume clock rate is configured as 10MHZ

void init_pins(void);
void init_i2c(void);
void sleep(void);
void set_alarm(void);
	
// Called on every wakeup
int main(void){
	RTC_ALMIN = (RTC_MIN + MEAS_PERIOD) % 60; // set alarm immediately. 
	INTWAKE = B(15); // RTC enabled to wake from deep power-down
	
	init_pins();
	// Set up the power registers
	
	// Only keep I2c and SPI. RTC is not needed as it does not run off the PCLK.
	// However, to set the RTC to a correct value, bit 9 must be enabled.
	// RTC initialization can be done using an interrupt routine in initialize.c
	PCONP = B(7) | B(8); 
	// Setup 
	init_i2c();
	record_data();
	
	PCON = 0x9E; // deep power down with all brownout mechanisms disabled
}

void init_i2c(void){
	// No interrupts: polling used
	// VICIntEnable = B(9);
	I20CONSET = 0x40;
	// Set i2c frequency to be 100kHz @ PCLK=10MHz
	I20SCLL = 50;
	I20SCLH = 50;
	// Setup I2C for sending data
	I20CONSET = B(6); //EN
}

void init_pins(void){

	// I2C0
	BIT_WRITE(PINSEL1, 0x1, 22, 23);
	BIT_WRITE(PINSEL1, 0x1, 22, 23);
	
	// SPI
	BIT_WRITE(PINSEL0, 0x3, 30, 31); // SCL
	BIT_WRITE(PINSEL1, 0x3, 2, 3);   // MISO 
	BIT_WRITE(PINSEL1, 0x3, 4, 5);   // MSIO
	FIO1DIR |= B(19); // Set CS pin to output.
	
	//BIT_WRITE(PINSEL1, 0x0, 6, 7); // use p0[19] for CS, which is GPIO
}
