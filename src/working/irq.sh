eabi-as irq.s -o irq.o
eabi-gcc handler.c -o handler.o
eabi-ld -T irqld.ld irq.o handler.o -o irq.elf
eabi-bin irq.elf irq.bin
qemu irq.bin

