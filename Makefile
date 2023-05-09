
build: boot/boot.asm
	nasm -f bin -o bin/boot/boot.bin boot/boot.asm

run: bin/boot/boot.bin
	qemu-system-i386 bin/boot/boot.bin

clean: bin/boot/boot.bin
	rm -r bin/*
