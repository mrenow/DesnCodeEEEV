				AREA bat_ram CODE

				EXPORT ram_meas;
				EXPORT ram_clear;
					
RAM_BASE		EQU 0xE0084000
RAM_END			EQU 0xE00847FF

; Records each measurement without byte alignment for maximum storage.
; First two bytes of memory designate the next free byte.
;
;
record_meas;(char byte)			
				MOV A1, #RAM_BASE
				LDR A2, [A1]; A1 = byte num
				STRB A0, [A1, A2]!; 
				MOV PC, LR
ram_clear;()
				MOV A0, #2;
				STRH A0, RAM_BASE; Store two bytes
				MOV PC, LR
				