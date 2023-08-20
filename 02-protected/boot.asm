%define SECTOR_SIZE 512
%define MBR_SIGNATURE 0xaa55
%define CUR_POS ($-$$)
%define ENTRY_POINT 0x7c00

%define NUM_SECTORS_TO_READ 1

org ENTRY_POINT
BITS 16

entry_point:
	jmp main

%include "print.asm"
%include "disk.asm"

main:
	mov al, NUM_SECTORS_TO_READ
	mov bx, ENTRY_POINT + SECTOR_SIZE ; read buff
	call disk_read

	call start_protected_mode

halt:
	cli
	hlt

; pad to 510 bytes
times SECTOR_SIZE - CUR_POS - 2 db 0
dw MBR_SIGNATURE

%include "gdt.asm"
%include "protect-mode.asm"

times SECTOR_SIZE * 2 - CUR_POS db 0
