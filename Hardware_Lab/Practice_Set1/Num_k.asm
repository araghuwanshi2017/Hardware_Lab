read_num:
	pusha
	mov word[num], 0
	loop_read:
		;; read a digit
		mov eax, 3
		mov ebx, 0
		mov ecx, temp
		mov edx, 1
		int 80h

		
		cmp byte[temp], 10
		je end_read
	
		mov ax, word[num]
		mov bx, 10
		mul bx
		mov bl, byte[temp]
		sub bl, 30h
		mov bh, 0
		add ax, bx
		mov word[num], ax
	jmp loop_read

	end_read:
	
		popa
		ret


print_num:
mov byte[count],0
pusha
extract_no:
inc byte[count]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
cmp ax , 0
je print_no
mov word[num], ax
jmp extract_no
print_no:
cmp byte[count], 0
je end_print
dec byte[count]
pop dx
mov byte[temp], dl
add byte[temp], 30h
mov eax, 4
mov ebx, 1
mov ecx, temp
mov edx, 1
int 80h
jmp print_no
end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h
;;The memory location ’newline’ should be declared with the ASCII key for new
popa
ret

read_array:
	pusha
	read_loop:
	cmp eax ,dword[n]
	je end_read_arr 
	call read_num

	mov cx , word[num]
	mov word[ebx + 2 * eax] , cx
	
	inc eax
	jmp read_loop	
	end_read_arr:
	popa
	ret


print_array:
pusha
print_loop:
cmp eax,dword[n]
je end_print1
mov cx,word[ebx+2*eax]
mov word[num],cx
;;The number to be printed is copied to ’num’ before calling print num function
call print_num
inc eax
jmp print_loop
end_print1:
popa
ret


section .data

msg1 : db 'Enter the size of the array',0ah
len_msg1 : equ $- msg1

msg2 : db 'Enter the elements ',0ah
len_msg2 : equ $- msg2

msg3 : db 'Enter the new element',0ah
len_msg3 : equ $- msg3

newline : db 10

section .bss
count : resb 1
num   : resw 1
temp  : resb 1
num1  : resw 1
num2  : resw 1
n     : resd 10
array : resw 50
k     : resw 1
num3  : resw 1

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
	mov ax , word[num]
	mov word[n] , ax
	

	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h

	mov ebx , array
	mov eax , 0
	call read_array
	

	mov eax , 4
        mov ebx , 1
        mov ecx , newline
       	mov edx , 1
        int 80h

	mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h
	

	mov word[num] , 0
	call read_num
	mov ax , word[num]
	mov word[k] , ax	
        	
	mov ebx , array
	mov word[num1] , 0
	mov word[num2] , 0 
	mov word[num3] , 0
	
	mov eax , 0	
	for:
		cmp eax , dword[n] 
		je exit
		mov ebx , 0
		mov ebx , array
		mov cx , word[ebx +2 * eax]
		inc eax
		cmp cx , word[k]
		je L1
		jna L2
		jnb L3
		
	L1:
        inc word[num1]
        jmp for

        L2:
        inc word[num2]
        jmp for

        L3:
        inc word[num3]
        jmp for


exit:


	mov cx , word[num3]
	mov word[num] ,cx
	call print_num

	mov cx , word[num2]
	mov word[num] , cx
	call print_num

	mov cx , word[num1]	
	mov word[num] , cx
	call print_num
	
	mov eax , 1
	mov ebx , 0
	int 80h
