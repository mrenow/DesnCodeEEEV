#include "lpc24xx.h"
#include "peripheral.h"

#define BMASK(start, end) ((0xFFFFFFFF>>(31-(end)+(start)))<<(start))
#define B(n) 1<<n
#define BIT_WRITE(reg, val, start, end) reg=(reg&~BMASK(start, end))|(val<<start);


extern void write_flash(int data, char len);
/*
 * Assume that the external 32.786kHz clock is configured externally
 * This function will only need to be called once on device initialization,
 * as RTC registers are not reset on reset as long as VBAT is held constant.
 * Values will need to be externally entered.
 */
 
void init_rtc(short year, char month, short doy, char dom, char dow, char hour, char minute, char second){
	// Turn off clk so that it can be set to its initial values,
	// Make sure that clock source is from external RTC.
	
	PCONP = B(9); // Enable writing to RTC 
	RTC_CCR = 0x10; // CLKEN=0, CLKSRC=1
	RTC_YEAR = year;
	RTC_MONTH = month;
	RTC_DOY = doy;
	RTC_DOM = dom;
	RTC_DOW = dow;
	RTC_HOUR = hour;
	RTC_MIN = minute;
	RTC_SEC = second;
	// Only trigger interrupts on alarms
	RTC_ILR = B(2);
	// Alarm mask register is set to only consider number of minutes
	RTC_AMR = ~B(1);
	// Set alarm two minutes from now
	RTC_ALMIN = RTC_MIN + 2;
	
	// Enable clock 
	RTC_CCR = 0x11; // CLKEN=1, CLKSRC=1
	
	// Clear battery ram:
	(*(volatile unsigned short*)(0xE0084000)) = 0;
	
	
}

void init_flash(){
	/* Write to flash:
	 * - Length of proceeding data section
	 * - Current time in minutes
	 * - Number of peripherals
	 * - Bit numbers for each peripheral
	 */
	
	write_flash(0, 32); // Length register
	write_flash(RTC_YEAR, 12); // 0 to 4096 
	write_flash(RTC_MONTH, 4); // 1 to 12
	write_flash(RTC_DOM, 5);   // 1 to 31
	write_flash(RTC_HOUR, 5);  // 0 to 23
	write_flash(RTC_MIN, 6);   // 0 to 59
	// Its word aligned!! wtf!! :)
	write_flash(N_PRPHLS, 8);
	
	peripheral_t prphls[N_PRPHLS] = ALL_PRPHLS;
	for (int i = 0; i < N_PRPHLS; i++){
		write_flash()
	}
	
	
	

}
