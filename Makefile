NAME=armstrong_numbers
AS=nasm
CC=gcc

all:
	$(AS) -f elf64 $(NAME).asm -o $(NAME).o
	$(CC) $(NAME).o -m64 -no-pie -o $(NAME)
