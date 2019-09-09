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
msg1: db 'Enter First Number',0ah
len_msg1: equ $- msg1

msg2: db 'Enter Second Number',0ah
len_msg2: equ $- msg2

newline : db 10

section .bss 

num1 :resw 1
num2 : resw 1
temp : resb 1
count : resb 1
num : resw 1


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
	mov word[num1] , ax

	mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h

        mov word[num] , 0
        call read_num
        mov ax , word[num]
	mov word[num2] , ax

	mov ax , word[num1]
	mov bx , word[num2]

	
	cmp ax , bx
	je L3
	jna L1
	jmp L2
	
	L1:
	sub bx , ax
	mov word[num] , bx
	call print_num 
	jmp exit
	
	L2:
	sub ax , bx
	mov word[num] , ax
	call print_num
	jmp exit
	
	L3:
	mov word[num] , 0
	mov word[num] , 30h
	mov eax , 4
	mov ebx , 1
	mov ecx , num
	mov edx , 1
	int 80h
 
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h 
	jmp exit
	
	exit:
	mov eax , 1
	mov ebx , 0
	int 80h

	

