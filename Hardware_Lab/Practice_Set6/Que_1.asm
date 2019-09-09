
section .data
msg1 : db"Enter number of rows in a matrix :"
len_msg1 : equ $-msg1

msg2 : db "Enter number of columns in a matrix :"
len_msg2 : equ $-msg2

newline : db 10

space   : db ' '

format1 : db"%d",0
format2 : db "%lf", 0
format3 : db"%lf ",0ah
section .bss
count : resb 1
temp  : resb 1
num   : resd 1
n     : resd 1  ;; Number of Rows
m     : resd 1  ;; Nmuber of columns
matrix: resq 100 
float1 : resq 1
section .text
global main:
extern scanf
extern printf


main:
	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	call read_num
	mov ax , word[num]
	mov word[n] , ax

	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h


	call read_num
	mov ax , word[num]
	mov word[m] , ax
	
	call read_float
	fstp qword[float1] 
	fld qword[float1]

	call print_float
	
	mov ebx , matrix
	call read_matrix

	;mov ecx , matrix
	;call print_matrix
	call exit



print_matrix:
	pusha
	mov eax , 0
	mov ecx , 0
pm1:
	cmp ecx , dword[n]
	je end_printing
	mov edx , 0

	pm2:
		cmp edx , dword[m]
		je L2
		
		fld qword[ebx + 8 * eax] 
		call print_float
		ffree st0
		inc edx
		inc eax
		jmp pm2

L2:
	inc ecx 
	jmp pm1

end_printing:
	call new_line
	popa
ret
	
read_matrix:
	pusha
	mov eax , 0
	mov ecx , 0
matrix1:
	cmp ecx , dword[n]
	je end_reading
	mov edx , 0		

	matrix2:
		cmp edx , dword[m]
		je L1
			
		call read_float
		fstp qword[ebx + 8 * eax]
		inc edx
		inc eax
		jmp matrix2

L1:
	inc ecx
	jmp matrix1

end_reading:
	popa
ret

exit:
        mov eax , 1
        mov ebx , 0
        int 80h



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


print_float:
	pusha
        push ebp
        mov ebp , esp
        sub esp , 8
        fst qword[ebp - 8]
        push format3
        call printf
        mov esp , ebp
        pop ebp
	popa
ret

read_float:
        push ebp
        mov ebp , esp
        sub esp , 8
        lea eax , [esp]
        push eax
        push format2
        call scanf
        fld qword[ebp - 8]
        mov esp , ebp
        pop ebp
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

        pusha
        mov eax , 4
        mov ebx , 1
        mov ecx , temp
        mov edx , 1
        int 80h
        popa

        jmp print_no

end_print:
        call new_line
        popa
ret

read_num:	
	push ebp	
	mov ebp , esp
	sub esp , 2
	lea eax , [esp]
	push eax	
	push format1
	call scanf
	mov ax , word[ebp - 2]
	mov word[num] , ax
	mov esp , ebp
	pop ebp 
ret








	
