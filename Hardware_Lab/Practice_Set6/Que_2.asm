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
	pusha
	mov eax , 1
	mov ebx , 0
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

read_string:
	pusha
	mov eax , 0
reading:
	pusha
	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h
	popa

	cmp byte[temp] , 10
	je end_reading
	
	inc eax
	mov cl , byte[temp]	
	mov byte[ebx] , cl
	inc ebx 
	jmp reading

end_reading:
	mov byte[ebx] ,0 
	inc ebx	
	mov dword[len] , eax 
	popa
ret


print_string:
	pusha
	mov eax, 0

print:	
	cmp byte[ebx] , 0
	je end_printing
	
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
	jmp print
	
end_printing:
	call new_line
	popa
ret


read_num:	
	pusha
	mov word[num] , 0
read:
	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h 

	cmp byte[temp]  , 10
	je end_read
	
	mov ax , word[num]
	mov bl , byte[temp]
	sub bl , 30h
	mov bh , 0
	add ax , bx
	mov word[num] , ax
	jmp read

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

sort_string:
	pusha
	mov dx , word[len]
	dec dx
	mov ecx , 0
sort1:
	cmp ecx , dword[len]
	je end_sorting

	mov eax , 0
	
	sort2:
		cmp eax , edx
		je L1
		
		push ecx
		mov cl , byte[ebx + eax]
		inc eax
		cmp cl , byte[ebx + eax]
		ja L2
		pop ecx
		jmp sort2

L2:
	push edx
	mov edx , eax
	dec edx
	mov cl , byte[ebx + edx]
	mov byte[temp] , cl
	mov cl , byte[ebx + eax]
	mov byte[ebx + edx] , cl
	mov cl , byte[temp]
	mov byte[ebx + eax] , cl
	pop edx
	pop ecx
	jmp sort2
	
L1:
	inc ecx 
	jmp sort1

end_sorting:
	popa 
ret

check_anagram:	
	pusha
	mov eax , 0
chk:
	cmp eax , dword[l1]
	je end_chk

	mov dl , byte[ebx + eax]
	cmp dl , byte[ecx + eax]
	jne Lb1
	inc eax
	jmp chk
Lb1:
	mov word[num] , 0
	popa
ret

end_chk:
	mov word[num] , 1
	popa
ret


check_cons:
	pusha
	xor edx , edx
	mov edx , dword[l1]
	dec edx
	mov eax , 0
cons1:
	cmp eax , edx
	je end_cons

	push edx
	mov cl , byte[ebx + eax]	
	inc eax
	mov dl , byte[ebx + eax]
	sub dl , cl
	cmp dl , 1
	jne ll1
	pop edx
	jmp cons1

ll1:
	mov word[num] , 0	
	pop edx
	popa 
ret

end_cons:	
	mov word[num] , 1
	popa
ret
	
section .data
msg1     : db 'Enter first string :'
len_msg1 : equ $-msg1

msg2     : db 'Enter second string :'
len_msg2 : equ $-msg2

msg3     : db'The strings are not anagram',0ah
len_msg3 : equ $-msg3

msg4     : db'The strings are anagram',0ah
len_msg4 : equ $-msg4

msg5     : db'String contains consecutive letters and each letter exactly ones',0ah
len_msg5 : equ $-msg5

msg6     : db'Condition fails to satisfy',0ah
len_msg6 : equ $-msg6

newline  : db 10

space    : db ' '

section .bss
count : resb 1
temp  : resb 1
num   : resd 1
n     : resd 1
len   : resd 1
l1    : resd 1
l2    : resd 1 
str1  : resb 50 
str2  : resb 50
section .text
global _start:
_start:

	mov eax , 4
	mov ebx , 1 
 	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	mov ebx , str1
	call read_string
	mov ax , word[len]
	mov word[l1] , ax
	call sort_string
	
;	mov eax , 4
;	mov ebx , 1
;	mov ecx , msg2
;	mov edx , len_msg2
;	int 80h
;
;	mov ebx , str2
;	call read_string
;	mov ax , word[len]
;	mov word[l2] , ax
;	call sort_string

;	mov ebx , str1
;	mov ecx , str2	
;	call check_anagram

;	call print_string
	mov ebx , str1
	call check_cons
	cmp word[num] , 0
	jne Label1
	jmp Label2


Label1:
	mov eax , 4
	mov ebx , 1
	mov ecx, msg5
	mov edx , len_msg5
	int 80h
	call exit

Label2:
	mov eax , 4	
	mov ebx , 1
	mov ecx , msg6
	mov edx , len_msg6
	int 80h
	call exit	
