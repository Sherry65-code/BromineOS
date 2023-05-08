cboot: boot/boot.asm
	nasm -f bin -o boot/boot.bin boot/boot.asm
test: boot/boot.bin
	qemu-system-i386 boot/boot.bin
