%define DISK_INTERUPT 0x13
%define DISK_READ_OP 0x2

; ---> int disk_read(al: num_sectors, dl: drive, bx buff) <---
disk_read:
	mov ah, DISK_READ_OP
	mov cx, 0x0002 ; ch cylinder; cl 1 based sector num
	mov dh, 0      ; dh head; dl device
	int DISK_INTERUPT

	jc .disk_error	    	 ; CF set on error
	jmp .return

.disk_error:
	push ax
	mov si, sp
	mov cx, 2
	call print_hex
	call print_newline

	mov si, disk_err_msg
	call print_str

	call halt

.return:
	mov si, disk_success
	call print_str
	call print_newline
	ret
; ---> end disk_read <---

disk_err_msg: db "disk error", 0
disk_success: db "disk success", 0
