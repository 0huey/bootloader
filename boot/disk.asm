%define DISK_INTERUPT 0x13
%define DISK_READ_EX 0x42

; ---> int disk_read(ax: num_sectors, bx: segment_buff, cx: sector_LBA, dl: drive) <---
disk_read:
	push bp
	mov bp, sp

	; setup disk address packet struct
	; https://en.wikipedia.org/wiki/INT_13H#INT_13h_AH=42h:_Extended_Read_Sectors_From_Drive

	; 8 byte sector start
	push 0
	push 0
	push 0
	push cx

	; 4 byte buffer as segment:offset
	shr bx, 4	; use the buff as segment to allow max 16-bit read
	push bx
	push 0		; offset 0 from segment

	; 2 byte sector read count
	push ax

	; struct size byte and reserved byte
	push 0x0010

	mov ah, DISK_READ_EX
	mov si, sp

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
	leave
	ret
; ---> end disk_read <---

disk_err_msg: db "disk error", 0
