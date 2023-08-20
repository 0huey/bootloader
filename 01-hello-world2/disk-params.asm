BITS 16

; ---> void disk_params (dl: disk) <---
disk_params:
	mov ah, 0x48
	mov dl, [var_bootdisk]
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
