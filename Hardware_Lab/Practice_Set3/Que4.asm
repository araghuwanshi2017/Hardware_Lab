_space:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , space
	mov edx , 1
	int 80h
	popa

ret

new_line:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h
	popa
ret

exit: 
	mov eax , 1
	mov ebx , 0
	int 80h
ret



print_num:
	pusha
	mov byte[count] , 0

extract_num:
	inc byte[count] 
	
	mov dx , 0
	mov ax ,word[num] 
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

	call _space
	popa
ret

read_array:

	pusha
	mov ebx , string
reading:
	push ebx
	mov eax ,3
	mov ebx ,0
	mov ecx ,temp
	mov edx ,1
	int 80h
	
	pop ebx
	cmp byte[temp], 10
	je end_reading

	inc word[string_len]
	mov dl , byte[temp]
	mov byte[ebx], dl

	inc ebx
	jmp reading

	end_reading:
	;; Similar to putting a null character at the end of a string
	mov byte[ebx], 0
	mov ebx, string

	popa
ret



print_array:
pusha
mov ebx, string
printing:
mov al, byte[ebx]
mov byte[temp], al
cmp byte[temp], 0
je end_printing
;; checks if the character is NULL character
push ebx
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
pop ebx
inc ebx
jmp printing
end_printing:
call new_line
popa
ret

section .data
msg1 :db'Enter a string :',0ah
len_msg1 : equ $-msg1

msg2 : db'The string is :',0ah
len_msg2 : equ $-msg2 

newline : db 10

space  : db ' '


section .bss
count  : resb 1
num    : resd 1
temp   : resb 1
string : resb 50
string_len : resd 1


section .text
global _start:
_start:

	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	call read_array
	
	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h

	call print_array
	
	mov ax , word[string_len]
	mov word[num] ,  ax
	call print_num
	call new_line	
	
	call exit
