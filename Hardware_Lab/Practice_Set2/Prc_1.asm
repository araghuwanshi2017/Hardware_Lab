print_num:

	mov byte[count] , 0
	pusha
extract_num:
	inc byte[count] 
	mov dx , 0
	mov ax , word[num]
	mov bx , 10	
	div bx
	push dx
	cmp ax , 0
	je print_no
	mov word[num] , ax
	jmp extract_num

print_no:
	cmp  byte[count] , 0
	je end_print
	dec byte[count]
	pop dx
	mov byte[temp] , dl
	add byte[temp] , 30h
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h

	jmp print_no
end_print:
	
	mov eax , 4
	mov ebx , 1	
	mov ecx , newline
	mov edx , 1
	int 80h
popa
ret

read_num:

mov word[num] , 0
loop_read:

mov eax , 3
mov ebx , 0
mov ecx , temp
mov edx , 1
int 80h

cmp byte[temp],10
je end_read

mov ax , word[num]
mov bx , 10
mul bx
mov bl , byte[temp]
sub bl , 30h
mov bh , 0
add ax , bx
mov word[num] , ax
jmp loop_read
end_read:
ret


section .data

msg1 :db 'Enter a element' , 0ah
len_msg1 : equ $- msg1

newline : db 10

section .bss
count : resb 1
temp  : resb 1 
num   : resd 1


section .text
global _start:
_start:

	mov eax , 4	
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	mov word[num] , 0
	call read_num
	mov ax , word[num]

	call print_num
	mov eax , 1
	mov ebx , 0
	int 80h


