global port_in_byte
global port_in_word
global port_in_dword
global port_out_byte
global port_out_word
global port_out_dword

port_in_byte:
	mov dx, [esp+4]
	in al, dx
	ret

port_in_word:
	mov dx, [esp+4]
	in ax, dx
	ret

port_in_dword:
	mov dx, [esp+4]
	in eax, dx
	ret

port_out_byte:
	mov dx, [esp+4]
	mov al, [esp+8]
	out dx, al
	ret

port_out_word:
	mov dx, [esp+4]
	mov ax, [esp+8]
	out dx, ax
	ret

port_out_dword:
	mov dx, [esp+4]
	mov al, [esp+8]
	out dx, eax
	ret
