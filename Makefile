# $@ = target file
# $< = first dependency
# $^ = all dependencies

# Set the assembler flags to look for include files in the boot/ directory
ASFLAGS = -f bin -Iboot/

all: run

kernel/kernel.bin: kernel/kernel-entry.o kernel/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel/kernel-entry.o: kernel/kernel-entry.asm
	nasm $< -f elf -o $@

kernel/kernel.o: kernel/kernel.c
	gcc -m32 -ffreestanding -c -fPIC $< -o $@ --no-pie

boot/mbr.bin: boot/mbr.asm boot/disk.asm boot/gdt.asm boot/switch-to-32bit.asm
	nasm $(ASFLAGS) $< -o $@

os-image.bin: boot/mbr.bin kernel/kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 -fda $<

clean:
	$(RM) *.bin *.o *.dis */*.bin */*.o

