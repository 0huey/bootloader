SHELL=/bin/bash

boot.img: boot kernel
	@if [[ -f $@ ]]; then rm $@; fi

	set -e; \
	for DIR in $^; do \
		make -BC $${DIR}; \
		cat $${DIR}/$${DIR}.bin >> $@; \
	done

	set -e; \
	KERNEL_SECTORS=$$(python3 util/sector-size.py kernel/kernel.bin); \
	python3 util/write-offset.py --word 508 $${KERNEL_SECTORS} $@

run: boot.img
	qemu-system-i386 -drive format=raw,file=$<

clean: boot kernel
	$(foreach dir, $^, make -C $(dir) clean;)
	rm *.img || true
