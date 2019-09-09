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
counter:resd 1
adr1   : resd 1
adr2   : resd 1
max    : resd 1
save   : resd 1
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

	mov word[max] , 0
	mov ebx , string
	mov word[adr1] , 0
	mov word[adr2] , 0
for_1:
	cmp byte[ebx ] , 0
	je end_while
	mov word[counter] , 0
	mov cl , byte[ebx]
	mov eax , 0
	while:
		cmp byte[ebx + eax] , cl
		jne L_1
		inc word[counter]
		inc eax 
		cmp byte[ebx + eax] , 0
		je L_1
		jmp while
L_1:
	mov dword[save] , ebx
	add ebx , eax
	mov cx , word[counter]
	cmp cx , word[max]
	ja L_2
	jmp for_1

L_2:
	mov ecx , dword[save]
	mov dword[adr1] , ecx
	mov dword[adr2] , eax

	mov cx , word[counter]
	mov word[max] , cx
	jmp for_1
end_while:

	mov ebx , dword[adr1]
	mov cl , byte[ebx]
	mov byte[temp] , cl
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa
	mov eax , dword[adr2]

	mov dword[num] , eax
	pusha
	call print_num
	popa
	mov edx , 0
	dec ebx 
	
fw:
	cmp edx , eax
	je exit

	inc edx
	mov cl , byte[ebx + edx] 
	mov byte[temp] , cl	
	
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	popa

	jmp fw
 				
	call exit
