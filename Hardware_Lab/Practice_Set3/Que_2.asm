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

	mov ax ,word[num] 
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


read_matrix:
	pusha
	mov word[num1] , 0
loop_1:
	mov word[num2] , 0
	
	loop_2: 
		call read_num
		mov cx , word[num]
		mov word[ebx + 2 * eax] , cx

		inc eax
		inc word[num2]
		mov cx , word[num2]
		cmp cx , word[m]
		jb loop_2

		inc word[num1]
		mov cx , word[num1]
		cmp cx , word[n]
		jb loop_1
		jmp end_loop_1

end_loop_1:
	popa
ret

print_matrix:
	pusha
	mov word[num1], 0
print_1:
	mov word[num2] , 0

	print_2:	
		mov cx , word[ebx + 2 * eax]
		mov word[num], cx
		call print_num
	inc eax 
	inc word[num2]
	mov cx , word[num2]
	cmp cx , word[m]
	jb print_2
	
	call new_line
	inc word[num1]
	mov cx , word[num1]
	cmp cx , word[n]
	jb print_1
	jmp end_print_1

end_print_1:
	popa
ret 
	
;; Function to Add two Matrices

add_matrix:
	pusha
	mov word[num1] , 0
add_1:
	mov word[num2] , 0
	
	add_2:
		mov ebx , matrix1
		mov cx  , word[ebx + 2 * eax]
		mov ebx , matrix2 
		mov bx  , word[ebx + 2 * eax]

		add cx , bx
		mov word[num] , cx
		call print_num
	inc eax
	inc word[num2]
	mov cx ,word[num2]
	cmp cx , word[m]
	jb add_2
	
	call new_line
	inc word[num1]
	mov cx , word[num1]
	cmp cx , word[n]
	jb add_1
	jmp end_add_1

end_add_1:
	popa
ret

;; Function to Multiply two Matrix 

matrix_mul:
	pusha
	mov word[num4] , 0
	mov eax , dword[adr1]
	mov dword[adr_r_1] , eax

	mov eax , dword[adr2]
	mov dword[adr_r_2] , eax
	
	mov eax , 0
mul_1:
	mov dword[num3], 0
	mov word[num1] , 0
	mul_2:
		mov dword[num3] , 0
		mov word[num2] , 0
		mov word[sum] , 0
		mul_3:
			mov eax , dword[num2]
			mov ebx , dword[adr1]
			mov ax , word[ebx + 2 * eax]
			mov word[save1] , ax
	
			inc dword[num2]
			mov eax , dword[num3]
			mov ebx , dword[m2]
			mul ebx

			inc dword[num3]
			mov  ebx ,dword[adr2]
			mov cx , word[ebx + 2 * eax]
			
			mov ax , word[save1]
			mov bx , cx
			mul bx

			add word[sum] , ax
			mov cx , word[num2]
			cmp cx , word[n2]
			jb  mul_3

			
			mov ax ,word[sum]  
			mov word[num] , ax
			call print_num


			inc word[num1]
			mov ebx , dword[adr2]
			add ebx , 2
			mov dword[adr2] , ebx

			mov ax , word[num1]
			cmp ax , word[m2]
			jb mul_2
			
			inc dword[num4]
			call new_line

			mov eax , dword[n2]
			mov ebx , 2
			mul ebx 

			mov ebx , dword[adr1]
			add ebx , eax
			mov dword[adr1] , ebx
			
			mov ebx , dword[adr_r_2]
			mov dword[adr2] , ebx
	
			mov ax , word[num4]
			cmp ax , word[n1]
			je end_mul_1
			jmp mul_1

end_mul_1:
	popa
ret
	
				
			
			
	 
section .data
msg1 : db'Enter number of rows in  first matrix :',0ah
len_msg1 : equ $- msg1

msg2 : db'Enter number of columns in first matrix :',0ah
len_msg2 : equ $- msg2

msg3 : db'Enter the elements of the  matrix :',0ah
len_msg3 : equ $- msg3

msg4 : db'Enter number of rows in  second matrix :',0ah
len_msg4 : equ $- msg4

msg5 : db'Enter number of columns in second matrix :',0ah
len_msg5 : equ $- msg5

msg6 : db'The sum of two matrices :',0ah
len_msg6 : equ $- msg6

newline : db 10

tab : db 9

space : db ' '
 
section .bss
temp  :resb 1
count :resb 1
num   :resd 1
num1  :resd 1
num2  :resd 1
i     :resd 1
j     :resd 1
n     :resd 1
m     :resd 1
n1    :resd 1;n1 number of rows
m1    :resd 1;m1 number of columns
n2    :resd 1
m2    :resd 1
adr1  :resd 1
adr2  :resd 1
adr_r_1 : resd 1
adr_r_2 : resd 1
num3   : resd 1
num4   : resd 1
sum    : resd 1
save1  : resd 1
matrix1:resw 200
matrix2:resw 200

section .text
global _start:
_start:

	;; Reading And Printing First Matrix
	mov eax , 4
	mov ebx , 1
	mov ecx , msg1	
	mov edx , len_msg1
	int 80h

	call read_num
	mov ax , word[num]
	mov word[n1] , ax
	mov word[n] , ax
	call print_num
	call new_line
	
	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h

	call read_num
	mov ax , word[num]
	mov word[m1] , ax
	mov word[m] , ax
	call print_num
	call new_line

	mov eax , 4
	mov ebx , 1
	mov ecx , msg3
	mov edx , len_msg3
	int 80h 
 
	mov eax , 0
	mov ebx , matrix1
	call read_matrix
	
	mov eax , 0
	mov ebx , matrix1
	call print_matrix

	;; Reading and Printing Second Matrix	
	mov eax , 4
        mov ebx , 1
        mov ecx , msg4
        mov edx , len_msg4
        int 80h

        call read_num
        mov ax , word[num]
        mov word[n2] , ax
	mov word[n] , ax
        call print_num
        call new_line

        mov eax , 4
        mov ebx , 1
        mov ecx , msg5
        mov edx , len_msg5
        int 80h

        call read_num
        mov ax , word[num]
        mov word[m2] , ax
	mov word[m] , ax 
        call print_num
        call new_line

        mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h

        mov eax , 0
        mov ebx , matrix2
        call read_matrix

        mov eax , 0
        mov ebx , matrix2
        call print_matrix
	
	mov ebx , matrix1
	mov dword[adr1] ,ebx

	mov ebx , matrix2
	mov dword[adr2] , ebx

	call new_line
	call matrix_mul
	
	call exit
