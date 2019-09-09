section .text
global main
extern scanf
extern printf


print:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp-8]
push format2
call printf
mov esp, ebp
pop ebp
ret


read:
push ebp
mov ebp, esp
sub esp, 8
lea eax, [esp]
push eax
push format1
call scanf
fld qword[ebp-8]
mov esp, ebp
pop ebp
ret

readnat:
push ebp
mov ebp, esp
sub esp , 2
lea eax , [ebp-2]
push eax
push format3
call scanf
mov ax, word[ebp-2]
mov word[num], ax
mov esp, ebp
pop ebp
ret

main:
mov eax , 4
mov ebx , 1
mov ecx , msg1
mov edx , len1
int 80h


call read

mov dword[var1] , 2
fimul dword[var1]
fst dword[var1]

mov dword[var2] , 22
fld dword[var2]
mov dword[var2] , 7
fdiv dword[var2]

fmul dword[var1]
call print


exit:
mov eax, 1
mov ebx, 0
int 80h
section .data
format1: db "%lf",0
format2: db "The average is : %lf",10
format3: db "%d", 0
msg1: db "Enter the number of floating numbers : "
len1: equ $-msg1
section .bss
num  : resw 1
num2 : resw 1
var1 : resd 1
var2 : resd 1
