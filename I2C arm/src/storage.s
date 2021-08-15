RAM_BASE		EQU 0xE0084000
RAM_END			EQU 0xE00847FF

SPI0_BASE		EQU	0xE0020000
PINSEL_BASE		EQU 0xE002C000
PINSEL1        	EQU 0x04
GPIO_BASE		EQU 0xE0028000
IOSET0          EQU 0x04
IODIR0          EQU 0x08


S0SPCR         	EQU 0x00
S0SPSR         	EQU 0x04
S0SPDR        	EQU 0x08
S0SPCCR        	EQU 0x0C

SCB_BASE 		EQU 0xE01FC000
PCONP           EQU 0xC4

SPIO_SEL		EQU 0x00010000
SPI0_MSTR		EQU 0x20
SPIF			EQU 0x80
				AREA bat_ram, CODE

				EXPORT record_meas;
				EXPORT write_flash;
				EXPORT begin_spi;
				EXPORT reset_spi;
					

; Records each measurement without byte alignment for maximum storage.
; First two bytes of memory designate the next free byte.
;

record_meas;(int data - 4 bytes,) 
				; If ram cannot contain next word, write all of ram to flash
				STMFD SP!, {V1, V2, LR}

				LDR A2, =RAM_BASE
				LDRH A3, [A2]; A3 = N bits
				ADD A3, #4
				LDR A4, =RAM_END
				ADD V1, A2, A3
				CMP V1, A4; Check if we have reached the end of ram
				STRHHI A3, [A2]; If not update n bits and store data to ram
				ADDHI A2, A2, A3
				STRHI A1, [A2]
				MOVHI PC, LR
				BL begin_flash; Else we must write all of ram to flash
				MOV V1, A1; lets move the new piece of data to v1 first
				MOV V2, #0
				STRH V2, [A2] # reset n bits to 0
				ADD A2, A2, #2.; ignoring the n bits area 
loop_write
				LDR A1, [A2], #4; load the data from ram post-indexed to next word
				BL write_flash
				CMP A4, A2; check that we have not reached RAM_END yet
				BHI loop_write; if not go to next peice of data and repeat write
end_loop_write	
				MOV A1, V1; finally move back new piece of data to A1 and write to flash
				BL write_flash
				BL end_flash

				LDMFD SP!, {V1, V2, LR}
				MOV PC, LR

begin_spi; ()
				STMFD SP!, {V1, V2, V3, LR}
				LDR V1, =SCB_BASE_ADDR
				MOV V2, #1, LSL #8
				STRB V2, [V1, #PCONP]; set pconp bit
				LDR V1, =SPI0_BASE
				MOV V2, 0x00
				STRB V2, [V1, #S0SPCR]; send reset to make sure spi is cleared before use just as is done in reset_spi but yeah
				LDR V3, =PINSEL_BASE
				MOV V2, 0xC, LSL #28
				STR V2, [V3]; setup SPI SCK
				MOV V2 0x0000003C
				STR V2, [V3, #PINSEL1]; setup SPI_SEL, MISO nd MOSI
				LDR V3, =GPIO_BASE
				LDR V2, =SPI_SEL
				STR V2, [V3, #IODIR0]
				STR V2, [V3, #IOSET0]
				MOV V2, 0x8
				STR V2, [V1, #S0SPCCR]; Set spi0 clock
				LDR V2, =SPI0_MSTR
				STRB V2, [V1, #S0SPCR]; set s0spcr to master mode
				LDMFD SP!, {V1, V2, V3, LR}	

reset_spi; () we reset the spi control register
				STMFD SP!, {V1, V2, LR}
				LDR V1, =SPI0_BASE
				MOV V2, 0x00
				STRB V2, [V1, #S0SPCR]
				LDMFD SP!, {V1, V2, LR}
				MOV PC, LR

write_flash; (int data)
				STMFD SP!, {V1, V2, V3, LR}
				LDR V1, =SPI0_BASE
				MOV V3, A1

				MOV V2, V3, ROR #24
				STRB V2, [V1, #S0SPDR]
				BL wait_finish
				MOV V2, V3, ROR #16
				STRB V2, [V1, #S0SPDR]
				BL wait_finish
				MOV V2, V3, ROR #8
				STRB V2, [V1, #S0SPDR]
				BL wait_finish
				STRB V3, [V1, #S0SPDR]
				BL wait_finish
				LDMFD SP!, {V1, V2, V3, LR}
				MOV PC, LR

wait_finish
				STMFD SP!, {V1, V2, LR}
				LDR V1, =SPI0_BASE
				LDR V2, [V1, #S0SPSR]
				LDR A1, =#SPIF
				TEQ V2, A1
				BNE wait_finish
				LDMFD SP!, {V1, V2, LR}
				MOV PC, LR


				END