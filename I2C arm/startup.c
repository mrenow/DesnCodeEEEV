#include "lpc24xx.h"
#include "peripheral.h"

#define BATRAM_BASE 0xE0084000
#define BMASK(start, end) ((0xFFFFFFFF>>(31-(end)+(start)))<<(start))
#define B(n) 1<<n
#define BIT_WRITE(reg, val, start, end) reg=(reg&~BMASK(start, end))|(val<<start);



void initPins(void);
void initI2C(void);

	
// Called on every wakeup
int main(void){
	INTWAKE = B(15); // RTC enabled to wake from deep power-down
	initPins();
	
	// Set up the power registers
	
	// Only keep I2c. RTC is not needed as it does not run off the PCLK.
	// However, to set the RTC to a correct value, bit 9 must be enabled.
	// RTC initialization can be done using an interrupt routine, but this
	// will not be implemnted.
	PCONP = B(7); 
	
	
	
	
}
void initI2C(void){
		// Enable interrupts from change in SI flag
	VICIntEnable = B(9);
	I20CONSET = 0x40;
}

void initPins(void){

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
