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
 

read_num:
	pusha
	mov word[num] , 0
	
read:	
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
	 
	mov bh , 0
	mov bl , byte[temp]
	sub bl , 30h
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
	call _space
	popa
ret	

read_array:
	pusha
	mov eax , 0

read1:
	cmp eax , dword[n]
	je end_read1

	call read_num
	mov cx , word[num]
	mov word[ebx + 2 * eax] , cx
	inc eax	
	jmp read1

end_read1:
	popa
ret

print_array:
	pusha
	mov eax , 0
print1:
	cmp eax , dword[n]
	je end_print1

	mov cx , word[ebx + 2 * eax]
	mov word[num] , cx
	call print_num
	inc eax
	jmp print1

end_print1:
	call new_line
	popa
ret


check_prime:
	pusha
	dec dword[n]
	mov ebx , 0
	mov ecx , arr
	mov word[num3] , 1
	for_Check:
		inc dword[num3]
		mov ecx , dword[num3]
		cmp ecx , dword[n]
		je end_Check
		

		mov dx , 0
		mov ax , word[n]
		inc ax
;		mov word[num] , ax
;		call print_num
		mov bx , word[num3]
;		mov word[num] , bx
;		call print_num
		div bx 
		mov word[num] , dx
		cmp word[num] , 0
;		mov word[num] , ax
;		call print_num
;		call new_line
		je print
		jmp for_Check
	print:	
		pusha
		mov eax , 4
		mov edx , 1
		mov ecx , msg3
		mov edx , len_msg3
		int 80h
		popa

		inc dword[n]
		mov dword[num] , 0
		popa
	ret

end_Check:
	mov dword[num] , 1
	popa
ret
	
sum_prime:
	pusha
	mov eax , 2
	mov edx , dword[n]
	mov dx , 0
	mov ax , word[n]
	mov bx , 0
	div bx 
	mov word[mid] , ax
	sub edx , eax
for_p:
	cmp eax , dword[mid]
	je end_for_p
	
	mov dword[num] , eax
	call check_prime
	cmp dword[num] , 1
	je L_1
	jmp L_2
L_1:
	mov dword[num] , edx
	call check_prime
	mov dword[num] , 1
	je L_3
	jmp L_2

L_3:
	call new_line
	mov dword[num] , eax
	call print_num

	mov dword[num] , edx
	call print_num

L_2:
	inc eax
	dec edx
	jmp for_p
	
end_for_p:
	popa
ret



msg1 : db 'Enter a number :',0ah
len_msg1 : equ $-msg1

msg2 : db'Enter the elements of array :',0ah
len_msg2 : equ $-msg2

msg3 : db'The sorted elements of array are :',0ah
len_msg3 : equ $-msg3

msg4 : db'The sum of distinct elements in array is : ',0ah
len_msg4 : equ $-msg4

msg5 : db'The minimum difference among the elements of array is : ',0ah
len_msg5 : equ $-msg5

newline : db 10

space : db ' '


section .bss
temp : resb 1
count: resb 1
num  : resd 1
arr  : resw 50
str  : resw 50
n    : resd 1
sum  : resd 1
counter : resd 1
min  : resd 1
start: resd 1
end  : resd 1
mid  : resd 1
num3 : resd 1
section .text
global _start:
_start:
	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	call read_num
	mov ax , word[num]
	mov word[n] , ax
	call check_prime
	call print_num
	call new_line
	call exit

	call sum_prime

	call exit

