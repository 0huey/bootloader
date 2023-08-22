SHELL=/bin/bash
EXPECTED_SIZE=512

boot.bin: boot.asm
	nasm $< -f bin -o $@

	@SIZE=$$(stat -c %s $@);	\
		if [[ $${SIZE} -ne $(EXPECTED_SIZE) ]]; then \
			echo "$@ is not $(EXPECTED_SIZE) bytes. actual: $${SIZE} bytes"; \
			false; \
		fi

	python3 ../util/write-offset.py --word 508 1 $@

run: boot.bin
	qemu-system-i386 -drive format=raw,file=$<

clean:
	@rm *.bin || true
