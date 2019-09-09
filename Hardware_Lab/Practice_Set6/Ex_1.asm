new_line:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , newline
	mov edx , 1
	int 80h
	popa
ret

_space:
	pusha
	mov eax , 4
	mov ebx , 1
	mov ecx , space
	mov edx , 1
	int 80h
	popa
ret
	
exit:	
	mov eax , 1
	mov ebx , 0
	int 80h
 

read_num:
	pusha
	mov word[num] , 0
	
read:	
	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h

	cmp byte[temp] , 10
	je end_read
 
	mov ax , word[num]
	mov bx , 10
	mul bx 
	 
	mov bh , 0
	mov bl , byte[temp]
	sub bl , 30h
	add ax , bx
	mov word[num] , ax
	jmp read

end_read:
	popa
ret


print_num:	
	pusha
	mov byte[count] , 0
	
extract_num:
	  	inc byte[count] 
	
		mov dx , 0
 		mov ax , word[num]
		mov bx , 10
		div bx 	
		push dx
			 
		mov word[num] , ax
		cmp ax , 0
		je print_no

		jmp extract_num


print_no:
	cmp byte[count] , 0
	je end_print

	dec byte[count]

	pop dx
	mov byte[temp] , dl
	add byte[temp] , 30h

	mov eax , 4	
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h

	jmp print_no

end_print:
	call _space
	popa
ret	

read_array:
	pusha
	mov eax , 0

read1:
	cmp eax , dword[n]
	je end_read1

	call read_num
	mov cx , word[num]
	mov word[ebx + 2 * eax] , cx
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

	mov cx , word[ebx + 2 * eax]
	mov word[num] , cx
	call print_num
	inc eax
	jmp print1

end_print1:
	call new_line
	popa
ret

sort_array:
	pusha
	mov eax , 0
	mov edx , dword[n]
	dec edx
for1:
	cmp eax , dword[n]
	je end_for1

	push eax
	mov eax , 0
	for2:
		cmp eax , edx 
		je L1
	
		mov cx , word[ebx + 2 * eax]
		inc eax
		cmp word[ebx + 2 * eax] , cx
		jb swap
		jmp for2

	swap:
		push edx
		mov dx , word[ebx + 2 * eax]
		mov word[num] , dx
		mov edx , eax
		mov word[ebx + 2 * edx] , cx
		mov cx , word[num]
		dec edx
		mov word[ebx + 2 * edx] , cx
		pop edx
	
		jmp for2

	L1:
		pop eax
		inc eax
		jmp for1

end_for1:
	popa 
ret
	
Elt_sprt:
	pusha
	mov eax , 0
	mov edx , dword[n]
	dec edx
es1:	
	cmp eax , dword[n]
	je end_es1
	es2:
		cmp eax , edx
		je end_es1
		
		mov cx , word[ebx + 2 * eax]
		inc eax
		cmp word[ebx + 2 * eax] , cx
		je es2
		jmp Label2
	Label2:
		push edx
		mov edx , dword[counter]
		push ebx
		mov ebx , str
		mov word[ebx + 2 * edx] , cx
		inc dword[counter]
		pop ebx
		pop edx

	jmp es1
		
end_es1:
	mov edx , dword[counter]
	mov eax , dword[n]
	dec eax
	mov cx , word[ebx + 2 * eax]
	mov ebx , str
	mov word[ebx + 2 * edx] , cx
	inc dword[counter]
	popa 
ret			


get_sum:
	pusha
	mov ebx , str
	mov eax , 0
_gs:	
	cmp eax , dword[n]
	je end_gs
	
	mov cx , word[ebx + 2 * eax]	
	add word[sum] , cx
	inc eax
		
	jmp _gs

end_gs:
	popa
ret


min_diff:	
	pusha
	mov ebx , str
	mov eax , 0
	mov edx , dword[n]
	dec edx
diff:
	cmp edx , eax
	je end_diff
	
	mov cx , word[ebx + 2 * eax]	
	inc eax
	push edx
	mov dx , word[ebx + 2 * eax]
	sub dx , cx

	cmp word[min] , dx	
	ja valc
	pop edx
	jmp diff

	valc:	
		mov word[min] , dx
		mov word[end] , cx
		mov word[start] , dx
		add word[start] , cx
		pop edx
		jmp diff

end_diff:
	popa
ret 		

	
	
	
section .data
msg1 : db 'Enter a number :',0ah
len_msg1 : equ $-msg1

msg2 : db'Enter the elements of array :',0ah
len_msg2 : equ $-msg2

msg3 : db'The sorted elements of array are :',0ah
len_msg3 : equ $-msg3

msg4 : db'The sum of distinct elements in array is : ',0ah
len_msg4 : equ $-msg4

msg5 : db'The minimum difference among the elements of array is : ',0ah
len_msg5 : equ $-msg5

newline : db 10

space : db ' '


section .bss
temp : resb 1
count: resb 1
num  : resd 1
arr  : resw 50
str  : resw 50
n    : resd 1
sum  : resd 1
counter : resd 1
min  : resd 1
start: resd 1
end  : resd 1
section .text
global _start:
_start:
	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx , len_msg1
	int 80h

	call read_num
	mov ax , word[num]
	mov word[n] , ax

	call print_num
	call new_line

	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h 
	
	mov ebx , arr
	call read_array 

	mov eax , 4
        mov ebx , 1
        mov ecx , msg3
        mov edx , len_msg3
        int 80h

;	mov ebx , arr
;	call print_array

	mov ebx , arr
	call sort_array

	mov ebx , arr
	call print_array

	mov word[counter] , 0
	mov ebx , arr
	call Elt_sprt
	
	mov ax , word[counter]
	mov word[n] , ax
	mov word[sum] , 0
	call get_sum
	
	mov eax , 4
	mov ebx , 1
	mov ecx , msg4
	mov edx , len_msg4
	int 80h 

	mov ax , word[sum]
	mov word[num] , ax
	mov word[min] , ax
	call print_num
	call new_line

	mov eax , 4
	mov ebx , 1
	mov ecx , msg5
	mov edx , len_msg5	
	int 80h

	call min_diff
	mov ax , word[min]
	mov word[num] , ax
	call print_num
	call new_line
	mov ax , word[start]
	mov word[num] , ax
	call print_num

	mov ax , word[end]
	mov word[num] , ax
	call print_num
	call new_line
	
;	mov ebx , str
;	call print_array
	call exit
	
