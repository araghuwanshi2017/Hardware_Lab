new_line:
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h
ret

exit:
	mov eax , 1
	mov ebx , 0
	int 80h
ret

read_num:
	pusha
	mov word[num] , 0
	
read_loop:
	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h
	
	cmp byte[temp] , 10
	je end_read
	
	mov ax , word[num]
	mov bx , 10
	mul bx
		
	mov bl ,byte[temp]
	sub bl , 30h
	mov bh , 0
	
	add ax , bx
	mov word[num] ,ax
	jmp read_loop

end_read:
	popa
ret

print_num:
	pusha
	mov byte[count] , 0
 extract_num:
	inc byte[count]
	mov dx , 0
	mov ax , word[num]
	mov bx , 10
	div bx
	
	push dx
	mov word[num] , ax
	cmp ax , 0
	je print_no
	jmp extract_num
	
print_no:
	cmp byte[count] , 0
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

	call new_line
popa
ret

read_array:
pusha

read_loop1:
	cmp eax , dword[n]
	je end_loop1
	mov word[num] , 0
	call read_num
	mov cx , word[num]
	mov word[ebx+2*eax] , cx
	inc eax
	jmp read_loop1

	
end_loop1:
	popa
ret

print_array:

pusha
print_loop1:

	cmp eax , dword[n]
	je end_print1
	call print_num
section .data

msg1: db 'Enter a number' ,0ah
len_msg1 : equ $- msg1

newline : db 10

section .bss
count : resb 1
temp  : resb 1
num   : resw 1
num1  : resd 1

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
	
	call print_num

	call exit
