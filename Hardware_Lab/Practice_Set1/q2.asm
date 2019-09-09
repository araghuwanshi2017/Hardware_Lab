section .data
msg1: db'Enter a Number',10
len_msg1: equ $- msg1

section .bss
digit:resb 1
count:resb 1

section .text
global _start:
_start:

	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	mov eax , 3
	mov ebx , 0
	mov ecx , digit
	mov edx , 1
	int 80h

	sub byte[digit] , 30h
	add byte[count] , 0
	
	for:
		add byte[count] , 30h
		mov eax , 4
		mov ebx , 1
		mov ecx , count
		mov edx , 1
		int 80h

		sub byte[count] , 30h
		add byte[count] , 1
		mov al , byte[count]
		cmp al , byte[digit]
		jna for

	mov eax, 1
	mov ebx, 0
	int 80h



