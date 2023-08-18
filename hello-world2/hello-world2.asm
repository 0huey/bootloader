%define ENTRY_POINT 0x7c00
%define SECTOR_SIZE 512
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
dw 0xaa55 ; MBR signature
msg: db "Hello from sector 2!", 0

; ---> void disk_params (dl: disk) <---
disk_params:
	mov ah, 0x48
	mov si, struct_disk_params
	int 0x13

	mov si, msg_cylinders
	call print_str
	mov si, struct_disk_params_cylinders
	mov cx, 4
	call print_hex

	call print_newline

	mov si, msg_heads
	call print_str
	mov si, struct_disk_params_heads
	mov cx, 4
	call print_hex

	call print_newline

	mov si, msg_spt
	call print_str
	mov si, struct_disk_params_sectors_per_track
	mov cx, 4
	call print_hex

	call print_newline

	mov si, msg_sectors
	call print_str
	mov si, struct_disk_params_total_sectors
	mov cx, 8
	call print_hex

	call print_newline

	mov si, msg_sector_size
	call print_str
	mov si, struct_disk_params_sector_size,
	mov cx, 2
	call print_hex
	ret

msg_cylinders: db "# cylinders: ", 0
msg_heads: db "# heads: ", 0
msg_spt: db "# sec/track: ", 0
msg_sectors: db "total sectors: ", 0
msg_sector_size: db "sector size: ", 0

struct_disk_params:						dw 0x1e ; size
struct_disk_params_flags:				dw 0
struct_disk_params_cylinders:			dd 0
struct_disk_params_heads:				dd 0
struct_disk_params_sectors_per_track:	dd 0
struct_disk_params_total_sectors:		dq 0
struct_disk_params_sector_size:			dw 0
struct_disk_params_optional:			dd 0

; pad to 4096 bytes
times SECTOR_SIZE * 8 - CUR_POS db 0
