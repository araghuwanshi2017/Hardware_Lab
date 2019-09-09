new_line:
	pusha

	mov eax , 4
	mov ebx, 1
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

	call new_line
	popa
ret



read_array:
	pusha
	mov eax , 0
	mov ebx , array	
read_loop1:
	cmp eax , dword[n]
	je end_read1

	call read_num	
	mov cx , word[num]
	mov word[ebx + 2*eax] , cx
	inc eax
	mov dx , word[sum]
	add cx , dx
	mov word[num] , cx
	mov word[sum] , cx

	jmp read_loop1

end_read1:
	popa
ret


print_array:
	pusha
	mov eax , 0
	mov ebx , array	
print_loop1:
	cmp eax , dword[n]
	je end_print1

	mov cx , word[ebx + 2 * eax]
	mov word[num] , cx
	call print_num

	inc eax
	jmp print_loop1

end_print1:
	popa
ret




section .data
msg1 : db'Enter the size of the array',0ah
len_msg1: equ $- msg1

msg2 : db 'Enter the elements',0ah
len_msg2 : equ $- msg2

newline :db 10

section .bss
count : resb 1
temp  : resb 1	
n     : resd 1
num1  : resd 1
num2  : resd 1
array : resw 50
counter  : resd 1
num   : resd 1
sum   : resd 1

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

	call print_num

	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h

	mov eax , 0
	mov ebx , array
	call read_array

	mov ecx , 0
	mov ebx , array
	for:
		mov ebx , array
		cmp ecx , dword[n]
		je end_for
		mov dx ,0
		mov ax , word[sum]
		sub ax , word[ebx + 2 * ecx]
		mov bx , word[ebx + 2 * ecx]
		div bx 
		cmp dx , 0
		je L1
		inc ecx
		jmp for
	L1:
	inc ecx 
	inc word[counter]
	jmp for

end_for:
	mov ax , word[counter]
	mov word[num] , ax
	call print_num
	
	call exit
