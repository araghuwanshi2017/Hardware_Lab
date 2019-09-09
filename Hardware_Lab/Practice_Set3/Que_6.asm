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

msg3 : db'The string is Palindrome :',0ah
len_msg3 : equ $- msg3

msg4 : db 'The string is not Palindrome :',0ah
len_msg4 : equ $- msg4

msg5 :db 'The reverse string is :',0ah
len_msg5 : equ $-msg5
newline : db 10

space  : db ' '


section .bss
start  : resd 1
mid    : resd 1
end    : resd 1
count  : resb 1
num    : resd 1
temp   : resb 1
string : resb 50
string_len : resd 1
counter: resd 1

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
	mov word[end] , ax

	mov dx , 0
	mov bx , 2
	div bx
		
	mov word[mid] , ax
	dec word[end]

	mov eax , 4
	mov ebx , 1
	mov ecx , msg5
	mov edx , len_msg5
	int 80h

	mov eax , 0
	mov ebx , string

	mov word[counter] , 0
	
for_c:
	cmp eax , dword[string_len]
	je end_for_c
	
	mov dl , byte[ebx + eax]	
	inc eax
	cmp dl ,byte[space]
	je L__1
	jmp for_c

L__1:
	inc word[counter]
	jmp for_c 


end_for_c:
	mov ax , word[counter]
	mov word[num] , ax
	call print_num
	call exit	
for:
	cmp eax , dword[string_len]
	je end_for_1

	mov edx , dword[end]
	mov cl , byte[ebx + edx]
	mov byte[temp] , cl
	dec word[end]

	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , temp
	mov edx , 1	
	int 80h

	popa
	inc eax
	jmp for

end_for_1:
	call new_line
	call exit
 
