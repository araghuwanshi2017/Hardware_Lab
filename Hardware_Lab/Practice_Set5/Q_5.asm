
_space:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , space
	mov edx , 1
	int 80h
	popa
ret
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
fstp dword[var1]
call read
fstp dword[var2]
call read
fstp dword[var3]

fld dword[var2]
fmul dword[var2]

fst dword[var5]

mov dword[var4] , 4
fld dword[var1]
fimul dword[var4]
fmul dword[var3]

fst dword[var4]
fld dword[var5]
fsub dword[var4]

fsqrt
fst dword[var4]
fld dword[var2]
fchs

fadd dword[var4]
fst dword[var6]
mov dword[var5] , 2
fld dword[var1]
fimul dword[var5]
fst dword[var5]
fst dword[var7]

fld dword[var6]
fdiv dword[var5]
call print

fld dword[var2]
fchs

fsub dword[var4]
fstp dword[var6]

fld dword[var6]
fdiv dword[var7]
call print

exit:
mov eax, 1
mov ebx, 0
int 80h
section .data
format1: db "%lf",0
format2: db "quadratic  root is : %lf",10
format3: db "%d", 0
space  : db ' '
msg1: db "Enter the number of floating numbers : "
len1: equ $-msg1
section .bss
num  : resw 1
num2 : resw 1
var1 : resd 1
var2 : resd 1
var3 : resd 1
var4 : resd 1
var5 : resd 1
var6 : resd 1
var7 : resd 1
