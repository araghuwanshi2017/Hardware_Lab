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



read_array:
        pusha
        mov eax , 0
read1:
        cmp eax , dword[n]
        je end_read1
	push eax
        call read
	pop eax
        fstp qword[ebx + 8 * eax] 
        inc eax
        jmp read1
end_read1:
        popa
ret

print_array:
	pusha
	mov eax , 0
print1:
	cmp eax , dword[n]
	je end_print1
	fld qword[ebx + 8 * eax]
	push eax
	call print
	pop eax	
	inc eax
	jmp print1

end_print1:
	popa 
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


sort_array:
	pusha
	xor edx,edx
	mov eax , 0
	mov dx , word[n]
	dec dx
sort1:	
	cmp eax , dword[n]
	je end_sort1
	
	mov ecx , 0
	sort2:
		cmp ecx , edx
		je L2
		fld qword[ebx + 8 * ecx]
		inc ecx 
		fld qword[ebx + 8 * ecx]
		fadd st1 
		fsub dword[k]
		fchs
		ffree st1
		fld qword[ebs]
		fcomi st1
		ja L1
		ffree st0
		ffree st1
		jmp sort2
L1:
	push eax
	mov eax , ecx
	dec eax
	fstp qword[ebx + 8 * eax]
	call print
	pop eax
	fstp qword[ebx + 8 * ecx]
	call print
	jmp sort2
L2:
	;ffree st0
	;ffree st1
	inc eax
	jmp sort1
		
end_sort1:
	popa
ret 
main:
	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len1
	int 80h

call readnat

mov ax , word[num]
mov word[n] , ax

call readnat
	
mov ax , word[num]
mov word[k] , ax


	mov eax , 4
	mov ebx , 2
	mov ecx , msg2
	mov edx , len_msg2
	int 80h 

mov ebx , array
call read_array

mov ebx , array
call sort_array

mov ebx , array
call print_array

exit:
mov eax, 1
mov ebx, 0
int 80h
section .data
format1: db "%lf",0
format2: db "%lf ",10,0h
format3: db "%d", 0
msg1: db "Enter the size of the array : "
len1: equ $-msg1
msg2: db'Enter the elements of the array :',0ah
len_msg2: equ $-msg2
ebs  : dq 0.00001
section .bss

num  : resw 1
n    : resd 1
k    : resd 1
var1 : resq 1
var2 : resq 1
array: resq 50
var3 : resq 1
