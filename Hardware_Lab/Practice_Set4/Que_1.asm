new_line:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h
	popa

ret

_space:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , space
	mov edx , 1
	int 80h
	popa
ret

exit:
	mov eax , 1
	mov ebx , 0
	int 80h

ret

read_string:
	pusha
reading:
	push ebx 
	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h
	pop ebx 

	cmp byte[temp] , 10
	je end_reading
	mov cl , byte[temp]
	mov byte[ebx] , cl
	inc ebx
	jmp reading
 
end_reading:
	mov byte[ebx] , 0
	inc ebx 
	popa
ret

print_string:
	pusha	
printing:
	cmp byte[ebx] , 0
	je end_printing
	mov cl , byte[ebx]
	mov byte[temp] , cl
	
	push ebx 
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	pop ebx

	inc ebx 
	jmp printing

end_printing:
	call new_line
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
section .data
msg1 : db'Enter first string',0ah
len_msg1: equ $- msg1

msg2 : db 'Enter second string',0ah
len_msg2 : equ $- msg2

newline : db 10

space : db ' '

section .bss
temp   : resb 1
string : resb 50
string1: resb 50
num    : resd 1
count  : resb 1

section .text
global _start:
_start:

	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	mov ebx , string	
	call read_string

	mov ebx , string
	call print_string

	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h

	mov ebx , string1
	call read_string
	
	mov ebx , string1
	call print_string

	mov ebx , string
	mov eax , string1

	mov word[num] , 65
	call print_num
for_1:
	cmp byte[eax] , 0
	je end_for_1

	cmp byte[ebx] , 0
	je end_for_1

	mov cl , byte[eax]
	cmp byte[ebx] , cl
	ja print_1
	jmp print_2

print_1:
	cmp byte[eax]  , ' '
	je end_print_1
	mov cl , byte[eax]
	mov byte[temp] , cl
	pusha
	mov eax ,4	
	mov ebx ,1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	inc eax
	cmp byte[eax] , 0
	je end_for_1
	jmp print_1
	
end_print_1:
	inc eax
	call _space
jmp for_1

print_2:
	cmp byte[ebx] , ' '
	je end_print_2
	mov cl , byte[ebx]
	mov byte[temp] , cl
	
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa

	inc ebx
	cmp byte[ebx] , 0
	je end_for_1
	jmp print_2
end_print_2:
	inc ebx
	call _space
jmp for_1

end_for_1:
	call _space
	cmp byte[eax] , 0
	je L_1
	jmp L_2
L_1:
	call print_string
	call exit
L_2:
	mov ebx , eax
	call print_string 
	call exit










