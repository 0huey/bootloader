%define ENTRY_POINT 0x7c00
%define SECTOR_SIZE 512
%define MBR_SIGNATURE 0xaa55
%define CUR_POS ($-$$)
%define NUM_SECTORS_READ 1

BITS 16
org ENTRY_POINT

entry:
	mov [var_bootdisk], dl
	call disk_read
	mov si, msg
	call print_str
	call print_newline
	call disk_params
	call halt

halt:
	cli
	hlt

%include "bios-print.asm"

disk_read:
	mov ah, 0x02   ; ah 0x2 disk read op
	mov al, NUM_SECTORS_READ
	mov cx, 0x0002 ; ch cylinder; cl 1 based sector num
	mov dh, 0      ; dh head; dl device was set to boot drive by bios
	mov bx, ENTRY_POINT + SECTOR_SIZE ; buff
	int 0x13

	jc .disk_error	    	 ; CF set on error
	cmp al, NUM_SECTORS_READ ; al set to number of sectors actually read
	jne .disk_error
	jmp .return

.disk_error:
	mov si, disk_err_msg
	call print_str
	call halt

.return:
	ret
; ---> end disk_read <---

disk_err_msg: db "disk rd err", 0

var_bootdisk: db 0

; pad to 510 bytes
times SECTOR_SIZE - CUR_POS - 2 db 0
dw MBR_SIGNATURE

; include a message in sector 2 we have to load
msg: db "Hello from sector 2!", 0

; include some code in sector 2 to call it
%include "disk-params.asm"

; pad to 1024 bytes
times SECTOR_SIZE * 2 - CUR_POS db 0
