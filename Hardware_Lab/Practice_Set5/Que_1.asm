comments:
	mov eax , 4	
	mov ebx , 1
	int 80h
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
	mov ax ,word[num] 
	mov bx , 10
	div bx
	push dx

	mov word[num], ax
	cmp ax , 0
	je print_no
	jmp extract_num

print_no:
	cmp byte[count] , 0
	je end_print
	
	dec byte[count] 
	pop dx

	mov byte[temp]  , dl
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


read_matrix:
	pusha
	mov eax , 0
	mov ecx , 0
for_matrix1:
	cmp ecx , dword[n]
	je end_read_matrix
	mov edx , 0	
	for_matrix2:
		cmp edx , dword[m]
		je L1

		call read_num
		push ecx
		mov cx , word[num]
		mov word[ebx + 2 * eax] , cx
		pop ecx

		inc edx 
		inc eax	
		jmp for_matrix2

L1:
	inc ecx 
	jmp for_matrix1

end_read_matrix:
	popa
ret

print_matrix:	
	pusha
	mov eax , 0
	mov ecx , 0
for_matrix_1:
	cmp ecx , dword[n]
	je end_print_matrix
	mov edx , 0
	for_matrix_2:
		cmp edx , dword[m]
		je L_1
		
		push ecx
		mov cx , word[ebx + 2 * eax]
		mov word[num] , cx
		pop ecx

		call print_num 
		inc edx
		inc eax
		jmp for_matrix_2

L_1:
	inc ecx
	call new_line
	jmp for_matrix_1
	
end_print_matrix:
;	call new_line	
	popa
ret

zig_zag:
	pusha
	mov ecx  , 0
z1:
	cmp ecx , dword[n]
	je end_z1
	mov eax , 0
	
	cmp word[num] ,0
	je z2	
	jmp z3
 
	z2:
		push ecx 
		mov cx , word[ebx]
		mov word[num] , cx
		pop ecx
		call print_num

		inc eax 
		mov word[num] , 1
		cmp eax , dword[m]
		je Label1
		inc ebx
		inc ebx
		jmp z2

	z3:
	
		push ecx
		mov cx , word[ebx]
		mov word[num] , cx
		pop ecx

		call print_num

		inc eax
		mov word[num] , 0
		cmp eax , dword[m]
                je Label1
		dec ebx 
		dec ebx

		jmp z3
Label1:
	inc ecx
	
	add ebx , eax
	add ebx , eax
	jmp z1

end_z1:
	popa
ret

	

section .data
msg1:db 'Enter rows in first matrix',0ah
len_msg1: equ $-msg1

msg2: db'Enter columns in first matrix',0ah
len_msg2 : equ $- msg2

msg3 : db'Enter rows in second matrix',0ah
len_msg3 : equ $- msg3

msg4 : db'Enter columns in second matrix',0ah
len_msg4: equ $- msg4

msg5 : db'Enter the elements of matrix',0ah
len_msg5 : equ $-msg5
newline : db 10

space : db ' '

section .bss
count : resb 1
temp  : resb 1
num   : resd 1
str   : resw 50
arr   : resw 50
n     : resd 1  ;; n represents Number of Rows
m     : resd 1  ;; m represents Number of Columns
n1    : resd 1
m1    : resd 1
n2    : resd 1
m2    : resd 1 

section .text
global _start
_start:

	
	mov ecx , msg1
	mov edx , len_msg1	
	call comments
	call read_num
	mov ax , word[num]
	mov word[n1] , ax
	
	mov ecx , msg2
	mov edx , len_msg2
	call comments
	call read_num
	mov ax , word[num]
	mov word[m1] , ax

	mov ecx , msg5
	mov edx , len_msg5
	call comments

	mov ax , word[n1]
        mov word[n] , ax
        mov ax , word[m1]
        mov word[m] , ax
        mov ebx , arr
        call read_matrix

        mov ebx , arr
        call print_matrix

	mov ebx , arr
	call zig_zag
	call exit

	mov ecx , msg3
	mov edx , len_msg3
	call comments
	call read_num
	mov ax , word[num] 
	mov word[n2] , 	ax

	mov ecx , msg4
	mov edx , len_msg4
	call comments  
	call read_num
	mov ax , word[num] 
	mov word[m2] , ax

	mov ecx , msg5
	mov edx , len_msg5
	call comments

	mov ax , word[n2]
	mov word[n] , ax
	mov ax , word[m2]
	mov word[m] , ax
	mov ebx , str
	call read_matrix

	mov ebx , str
	call print_matrix

	

call exit
