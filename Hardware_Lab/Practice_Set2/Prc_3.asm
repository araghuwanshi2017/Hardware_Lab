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
	mov word[num], 0

read_loop:
	mov eax , 3
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
;condition check
	cmp byte[temp], 10
	je end_read ;jump if equal to end condition
	mov ax , word[num]
	mov bx , 10
	mul bx
	
	mov bl , byte[temp]
	sub bl , 30h
	mov bh , 0
	
	add ax , bx
	mov word[num] , ax
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
	mov ax, word[num]
	mov bx , 10
	div bx
	
	push dx
	cmp ax , 0
	je print_no
	mov word[num] , ax
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
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h

	popa
ret

read_array:
	pusha

read_loop1:
	cmp eax , dword[n]
	je end_read1
	mov word[num] , 0
	call read_num
	mov cx , word[num]
	mov word[ebx + 2 * eax] , cx
	inc eax
	jmp read_loop1
	
end_read1:
	popa
	ret

print_array:
	pusha
print_loop1:
	cmp eax , dword[n]
	je end_print1
	
	mov cx , word[ebx + 2*eax]
	inc eax
	mov word[num] , cx
	call print_num
	jmp print_loop1
	
end_print1:

	popa
ret

section .data

msg1 : db 'Enter the size of the array',0ah
len_msg1 : equ $- msg1

msg2 : db 'Enter the elements of the array',0ah
len_msg2 : equ $- msg2

newline : db 10

section .bss

count : resb 1
temp  : resb 1
num   : resw 1
num1  : resd 1
num2  : resd 1
num3  : resd 1
n     : resd 1
arr   : resw 50

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
	mov ax ,word[num]
	mov word[n] , ax
	
	call print_num ;calling function to read a number
		
	; read an array
	mov eax , 0
	mov ebx , arr
	call read_array

	;printing an array
	mov eax , 0
	mov ebx , arr
	call print_array
	call exit
