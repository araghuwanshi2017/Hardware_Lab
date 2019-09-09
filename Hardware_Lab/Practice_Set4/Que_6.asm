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

msg3 : db 'Enter a number',0ah
len_msg3 : equ $- msg3

newline : db 10

space : db ' '

section .bss
temp   : resb 1
string : resb 50
string1: resb 50
num    : resd 1
count  : resb 1
n      : resd 1
counter: resd 1
adr1   : resd 1
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

	
        mov ebx , string
	mov eax , string1

for:
	cmp byte[ebx] , 0
	je end_for

	cmp byte[ebx] , 'a'
	je L1

	cmp byte[ebx] , 'e'
	je L1
	
	cmp byte[ebx] , 'i'
	je L1
	
	cmp byte[ebx] , 'o'
	je L1
	
	cmp byte[ebx] , 'u'
	je L1
	jmp L2
L1:
	mov byte[eax] , 'a'
	inc eax
	mov byte[eax] , 'n'
	inc eax

	mov cl , byte[ebx]
	mov byte[eax] , cl
	
	inc eax
	inc ebx
	jmp for

L2:
	mov cl , byte[ebx]
	mov byte[eax] , cl
	inc ebx 
	inc eax
	jmp for

end_for:
	mov byte[eax] , 0
	inc eax
	mov ebx , string1
	call print_string
	call exit
