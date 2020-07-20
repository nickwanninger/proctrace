default: test


test: test.asm
	nasm -felf64 test.asm -o test.o
	ld test.o -o test
