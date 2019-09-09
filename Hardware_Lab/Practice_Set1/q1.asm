section .data
msg1: db 'Enter first digit', 0ah
len_msg1: equ $- msg1

msg2: db 'Enter second digit',0ah
len_msg2: equ $- msg2

section .bss
digit1: resb 1
digit2: resb 1

sum_digits: resb 1
carry_digits: resb 1
junk: resb 1

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
	mov ecx , digit1
	mov edx , 1
	int 80h

	mov eax , 3
	mov ebx , 0
	mov ecx , junk
	mov edx , 1
	int 80h

	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h

	mov eax , 3
	mov ebx , 0
	mov ecx , digit2
	mov edx , 1
	int 80h

	sub byte[digit1] , 30h
	sub byte[digit2] , 30h
	mov ax , word[digit1]
	add ax , word[digit2]

	mov bl , 10
	mov ah , 0
	div bl

	mov byte[sum_digits] , al
	mov byte[carry_digits] , ah
	add byte[sum_digits] , 30h
	add byte[carry_digits] , 30h

	mov eax , 4
	mov ebx , 1
	mov ecx , sum_digits
	mov edx , 1
	int 80h

	mov eax , 4
	mov ebx , 1
	mov ecx , carry_digits
	mov edx , 1
	int 80h

	mov eax , 1
	mov ebx , 0
	int 80h

