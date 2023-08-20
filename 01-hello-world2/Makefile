
run: boot.bin
	qemu-system-i386 -drive format=raw,file=$<

boot.bin: hello-world2.asm
	nasm $< -f bin -o $@
	@ls -l $@  | awk '{print $$9 ": " $$5 " bytes"}'

clean:
	rm *.bin || true
