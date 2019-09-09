read_num:
;;push all the used registers into the stack using pusha
pusha
;;store an initial value 0 to variable ’num’
mov word[num], 0
loop_read:
;; read a digit
mov eax, 3
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
cmp word[num], 0
je print_no
inc byte[count]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
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

section .data
msg1: db'Enter a number',0ah
len_msg1: equ $-msg1

Odd: db 'Odd Number' , 0ah
len_Odd: equ $- Odd

Even: db 'Even Number' , 0ah
len_Even: equ $- Even

newline: db 10
 
section .bss
count:resb 1
temp: resb 1
num: resw 1


section .text
global _start:
_start:

	mov word[num] , 0
	call read_num
        mov ax , word[num]
        mov ah , 0	
	mov bl , 2
	div bl

	cmp  ah , 0
	je L1
		mov eax , 4
		mov ebx , 1
		mov ecx , Odd
		mov edx , len_Odd
		int 80h
		jmp exit
	
	L1: 
		mov eax , 4
		mov ebx , 1
		mov ecx , Even
		mov edx , len_Even
		int 80h
		jmp exit

	exit:
		mov eax , 1
		mov ebx , 0
		int 80h

 

	
