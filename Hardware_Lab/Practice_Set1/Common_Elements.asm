new_line:
	mov eax , 4
        mov ebx , 1
        mov ecx , newline
        mov edx , 1
        int 80h
	ret

read_num:
;;push all the used registers into the stack using pusha
pusha
;;store an initial value 0 to variable ’num’
mov word[num], 0
loop_read:
;; read a digit
mov eax, 3d
mov ebx, 0
mov ecx, temp
mov edx, 1
int 80h
;;check if the read digit is the end of number, i.e, the enter-key whose ASCII
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
;;pop all the used registers from the stack using popa
popa
ret

print_num:
mov byte[count],0
pusha
extract_no:
inc byte[count]
mov dx, ec 0
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
cmp eax,dword[n]
je end_read1
mov word[num] , 0
call read_num
;;read num stores the input in ’num’
mov cx,word[num]
mov word[ebx+2*eax],cx
inc eax
jmp read_loop
end_read1:
popa
ret


print_array:
pusha
print_loop:
cmp eax,dword[n]
je end_print1
mov cx,word[ebx+2*eax]
mov word[num],cx
;;The number to be printed is copied to ’num’before calling print num
call print_num
inc eax
jmp print_loop
end_print1:
popa
ret

section .data
msg1: db 'Enter the size of the array',0ah
len_msg1 : equ $- msg1 

msg2 : db 'Enter the elements',0ah
len_msg2: equ $-msg2

msg3 : db ' Enter the size of the second array',0ah
len_msg3 : equ $- msg3

newline : db 10

section .bss
temp  : resb 1
count : resb 1
n     : resd 1
num   : resd 1
num1  : resd 1
num2  : resd 1
num3  : resd 1
array : resw 50 
k     : resd 1
save  : resw 1
l     : resd 1
num4  : resd 1
str   : resw 50

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
	mov word[n] ,ax
	
	mov eax , 4
	mov ebx , 1
 	mov ecx , msg2
	mov edx , len_msg2
	int 80h
	
	mov eax , 0
	mov ebx , array
	call read_array
	
	mov eax , 4
        mov ebx , 1
        mov ecx , msg1
        mov edx , len_msg1
        int 80h
	
	mov word[num] , 0
        call read_num
        mov ax , word[num]
        mov word[n] ,ax

	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h

	mov eax , 0
	mov ebx , str
	call read_array

	mov eax , 0
	for:
		cmp eax , dword[n]
		je exit
 		mov ebx , array
		mov ecx , str
		mov bx , word[ebx + 2 * eax]
		mov cx , word[ecx + 2 * eax]
		inc eax
		cmp bx , cx
		je L1
		jmp for
	L1: 
	mov word[num] , bx
	call print_num
	jmp for
	
exit:
	mov eax , 1
	mov ebx , 0
	int 80h
