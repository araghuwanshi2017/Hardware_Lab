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
mov ecx ,0ah
mov edx,1
int 80h
popa
ret


section .data
msg1 : db 'Enter a Number',0ah
len_msg1: equ $-msg1
newline: db 10
l1: equ $-newline

section .bss
d1 :resb 1
d2 :resb 1
temp: resb 1
count:resb 1
num: resw 1
count1:resw 1
save:resw 1

section .text
global _start:
_start:
	
	mov eax ,4
        mov ebx ,1
        mov ecx ,msg1
        mov edx ,len_msg1
        int 80h
        mov word[num] , 0
	mov word[save] , 0	
	call read_num
	mov ax , word[num]
	mov word[count1] , 0
	mov word[save] , ax
	
	mov word[count1] , 30h
	mov eax , 4
	mov ebx , 1
	mov ecx , count1
	mov edx , 1
	int 80h
	mov word[count1], 1
	
	for:
		add word[count1] , 30h
		mov ax ,word[count1]
		mov word[num] , ax
		sub word[num] , 30h

		call print_num
		sub word[count1] , 30h
		add word[count1] , 1
		mov ax , word[count1]
		cmp ax , word[save]
		jna for
	mov eax , 1
	mov ebx , 0
	int 80h

	
