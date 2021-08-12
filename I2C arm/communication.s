				AREA communication CODE

				EXPORT read_i2c;
	
I2C0_BASE 		EQU 0xE001C000
	
I2C0NSET		EQU 0x00
I20STAT         EQU 0x04
I20DAT          EQU 0x08
I20ADR          EQU 0x0C
I20SCLH         EQU 0x10
I20SCLL         EQU 0x14
I20CONCLR       EQU 0x18
	
AA				EQU 0x04; Acknowledge bit
SI				EQU 0x08; 
STO				EQU 0x10
STA				EQU 0x20

; Variables:
; 	V1: Global I2C0_Base
; 	V5: Device address
;   V6: Device 
;
; Description:
;	reads one byte of data from the device at addr, at register req.
; 	Potentially recovers from errors by restarting transmission. May enter 
; 	an infinite loop if not setup correctly.
;
read_i2c; (char addr, char req) A3 dirty.
				STMFD SP! {V1, V5, V6, LR}
				
				LDR V1, =I2C0_BASE ; GLOBAL variable for base
				
				MOV V5, A1
				MOV V6, A2
				
				MOV A3, #AA; 
				STRB A3, [V1, #I2CONSET]; Acknowledge

start_transmission
				MOV A1, V5; Need to reset A1 incase of restart transmission
				MOV A2, 0x18;
				BL send_addr
		
				MOV A1, V6; Send req addr 
				MOV A2, 0x28; 
				BL send_data ; Send requested register
				
				ORR A1, V5, #1; Send slave address in read mode
				MOV A2, 0x40; 
				BL send_addr
				
				MOV A3, #AA
				STRB A3, [V1, #I2CONSET]; Send not Acknowledge on next data recieve
				MOV A2, 0x58;
				BL recv_data
				
				;MOV A1, A1; A1  already set in return value
				; Do not stop transmission until the end
				LDMFD SP! {V1, V5, V6, LR}
				MOV PC, LR
				
				
send_addr;(A1 = char addr, A2 = char next_state) A4, A3 dirty
				STR LR, [SP, #4]! ; Full descending 
				MOV A4, #STA
				; Send start bit
				STRB A4, [V1, #I20CONSET]
				BL resume
				
				STRB A4, [V1, #I20CONCLR]; Reset Start bit
				
				LDR LR, [SP], #4 ; Full descending 
				;BL send_data ; Save a branch by going direclty to send_data
				;The data to be sent is the address.
				;MOV PC, LR
				
send_data;(A1 = char data, A2 = char next_state) A4, A3 dirty. MUST Be called in main code block
				
				STR LR, [SP, #4]! ; Full descending
				STRB A1, [V1, #I20DAT]; Load data into dat
				BL resume
	
				LDR A4, [V1, #I20STAT] ; Check for error
				TEQ A4, A2; If not in expected state
				BNE restart_transmission; Transmission restart needed
				
				LDR LR, [SP], #4 ; Full descending 
				MOV PC, LR
				
restart_transmission; MUST be called one calls down from main code block.
				
				MOV A4, #STO
				STRB A4, [V1, #I20CONSET]; Stop transmission
				BL resume	; Wait for stop bit to send
				LDR LR, [SP], #8 ; Revert SP to two calls back.
				B start_transmission

recv_data; (A2 = char next_state) 		
				STR LR, [SP, #4]! ; Full descending
				; Now waiting on data
				BL resume
				LDR A4, [V1, #I20STAT] ; Check for error
				TEQ A4, A2; If not in expected state
				BNE restart_transmission; Transmission restart needed
				LDRB A1, [V1, #I20DAT]; obtain 
				LDR LR, [SP], #4 ; Full descending 
				MOV PC, LR

resume;() A3 Dirty
				; Clear SI bit to send transmission
				MOV A3, #SI
				STRB A3, [V1, #I20CONCLR];
resume_loop
				LDR A3, [V1, #I20CONSET];
				TST A3, #SI; Check SI bit
				BEQ resume_loop ; Loop if zero

				MOV PC, LR


