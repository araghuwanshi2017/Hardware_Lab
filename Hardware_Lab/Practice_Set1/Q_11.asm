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



read_num:

pusha

mov word[num] , 0
loop_read:

mov eax ,3
mov eax , 0
mov ecx , temp
mov edx , 1
int 80h

cmp byte[temp],10
je end_read

mov ax , word[num]
mov bx , 10
mul bx
mov bl , byte[temp]
sub bl , 30h
mov bh , 0
add ax , bx
mov word[num] , ax
jmp loop_read
end_read:
popa
ret

