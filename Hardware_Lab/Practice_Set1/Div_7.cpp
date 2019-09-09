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


newline : db 10

section .bss
count : resb 1
temp  : resb 1
num   : resw 1
num1  : resw 1


section .text
global _start:
_start:

	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	mov ebx , 0
	mov ebx , array
	call read_array

	call print_array

