cboot: boot/boot.asm
	nasm -f bin -o boot/boot.bin boot/boot.asm
test: boot/boot.bin
	qemu-system-i386 boot/boot.bin
liveboot: boot/boot.bin
	dd if=boot/boot.bin of=/dev/sda2 bs=1M status=progress
