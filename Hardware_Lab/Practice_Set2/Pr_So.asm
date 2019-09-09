									;***************************************
									;********AKASH RAGHUWANSHI*************
									;***************************************
									;**********HARDWARE LAB*****************
									;***************************************
									;***********NASM CODE*******************
									;***************************************


%include 'Function.asm'									
; read_num

; print_num

; read_array

; print_array

; Sort_array

; Find_Max

; Find_min

; Sum_Digits

; Check_Prime

; E_Occur

; K_Elt

; binary_Search

; Exit

; Common_Elt

; Newline 


new_line:

        mov eax , 4
        mov ebx , 1
        mov ecx , newline
        mov edx , 1
        int 80h
ret

; Function to find Common elemetns in an array

Common_Elt:



; Function to find Occurrence of every element in an array in O(n^2) time

E_Occur:











; Function to find Kth largest element in an array using sort function in O(n^2) time
; Prints Kth Largest element

k_Elt:
	pusha
	mov word[num] , 0
	call read_num
	mov bx , word[num]
	mov ax , word[n]
	sub ax , bx
	mov word[k] , ax
	call print_num
	
	mov eax , 0
	mov ebx , arr
	call sort_array
	
	mov eax , 0
	mov ebx , arr
	call print_array

	mov eax , dword[k]
	mov ebx , arr
	mov cx , word[ebx + 2* eax]
	mov word[num] , cx
	
	call print_num
	popa
ret

; Function to search an Element in an array in O(logn) time
; Prints Element if found 
; else Prints Not Found Msg

binary_Search:
	pusha
	mov dword[adr] , ebx
	mov word[start] , 0	
	mov ax , word[n]
	dec ax
	mov word[end] , ax

	mov ax,word[num]
	mov word[l] , ax

	while: ;while(l <= r)
		mov ax , word[start] 
		cmp ax , word[end]  
		ja end_while	     ; if(l > r) break;
	
		mov dx , 0
		mov ax , word[start] ; start = l
		mov cx , word[end]  ; end = r
		add ax , cx         ; (l + r)
		mov bx , 2          ; 
		div bx   
		
		mov  word[mid] , ax ; mid = (l + r)/2       

		mov eax ,dword[mid] 
		mov ebx , dword[adr]
		mov cx , word[l]
		cmp word[ebx + 2 * eax] , cx ;check relation b/w arr[mid]  and Searched element num
		je get_element               ; if(arr[mid] == x) 
		ja L_l			     ; else if(arr[mid] > x)
		jmp L_r			     ; else for arr[mid] < x
	L_l:

	mov ax ,word[end]
	cmp ax, 0
	je end_while

	mov dword[end] , eax
	dec dword[end]
	jmp while
	L_r:
	mov dword[start] , eax
	inc word[start]
	jmp while

get_element:
	mov word[num] ,1

	popa
ret
	
end_while:
	;mov eax , 4	  
	;mov ebx , 1  
	;mov ecx , msg6       ; Element Not Found
	;mov edx , len_msg6
	;int 80h

	mov word[num] , 0
	popa
ret                                        ; return

; Function to check whether a number is prime or not in O(n^2) time
; if(Prime) Prints it;
; else Prints Not Prime 

prime_Check:
	pusha
	dec dword[n]
	mov ebx , 0
	mov ecx , arr
	mov word[num3] , 1
	for_Check:
		inc dword[num3]
		mov ecx , dword[num3]
		cmp ecx , dword[n]
		je end_Check
	
		mov dx , 0
		mov ax , word[num]
		mov bx , word[num3]
		div bx 
		cmp dx , 0
		je L__2
		jmp for_Check
	L__2:	
		mov eax , 4
		mov edx , 1
		mov ecx , msg3
		mov edx , len_msg3
		int 80h
		inc dword[n]
		popa
	ret

end_Check:
	inc dword[n]
	call print_num
	popa
ret
		
; Function to calculate sum of digits of a number in O(k) k represent no of digits		
; Returns sum of digits in Word[sum] 

;sum_digits:	
;	pusha
;	mov word[sum] , 0
;	for_sum:
;		cmp word[num] , 0
;		je end_for_sum
;		mov dx , 0
;		mov ax , word[num]
;		mov bx , 10
;		div bx
;
;		mov word[num] , ax
;		mov ax , word[sum] 
;		add ax , dx
;		mov word[sum] , ax
;		jmp for_sum
;	
;end_for_sum:
;	popa
;ret

	
; Function to find_Minimum element in an array in O(n) time
; Returns minimum element in word[min]

Find_Min:
        pusha
        mov ebx , arr
        mov ax , word[ebx]
        mov word[min] , ax
        mov eax , 0
        mov ebx , arr
        for_min_1:
                cmp eax , dword[n]
                je end_for_min
                mov cx , word[ebx + 2 * eax]
                inc eax

                cmp cx , word[min]
                jb L_2
                jmp for_min_1
        L_2:
        mov word[min] , cx
        jmp for_min_1

end_for_min:
        popa
ret

; Function to find_Max element in an array in O(n) time
; Returns max element in Word[max]

Find_Max:
	pusha
	mov ebx , arr
	mov ax , word[ebx]
	mov word[max] , ax
	mov eax , 0
	mov ebx , arr
	for_max_1:
		cmp eax , dword[n]
		je end_for_max
		mov cx , word[ebx + 2 * eax]
		inc eax
		
		cmp cx , word[max]
		ja L_1
		jmp for_max_1
	L_1:
	mov word[max] , cx
	jmp for_max_1

end_for_max:

	call new_line
	popa
ret

; Function to sort an array in O(n^2) time
sort_array:
	pusha
	mov  dword[adr],ebx
	mov dword[num1] , 0
	mov dword[num2] , 0
	mov ax , word[n]
	mov word[l] , ax
	dec dword[l]
for_sort1:
	mov eax , dword[num1] 
	cmp eax , dword[n]
	je end_for_sort
	inc dword[num1]
	mov dword[num2] , 0
	for_sort2: 
		mov ebx , dword[adr]
		mov ecx , dword[num2]
		cmp ecx , dword[l]
		je for_sort1
		inc dword[num2]
		mov ax , word[ebx + 2 * ecx]
		mov word[num3] , ax
		mov ecx , dword[num2]
		mov bx , word[ebx + 2 * ecx]
		mov word[num4] , bx
		cmp ax , bx
		ja L1
		jmp for_sort2
	L1:
	mov ebx , dword[adr]
	mov ecx , dword[num2]
	mov ax  , word[num3]
	mov word[ebx + 2 * ecx] , ax
	dec ecx
	mov ax , word[num4]
	mov word[ebx + 2 * ecx] , ax

	jmp for_sort2

end_for_sort:
	popa
ret
	
;Exit Function 
exit:
	mov eax , 1
	mov ebx , 0
	int 80h
ret

;Function to read a number	
read_num:
	pusha
	mov word[num] , 0

read_loop:
	mov eax , 3
	mov ebx , 1
	mov ecx , temp
	mov edx , 1
	int 80h
	
	cmp byte[temp] , 10
	je end_read

	mov ax , word[num]
	mov bx , 10
	mul bx

	mov bl , byte[temp]
	sub bl , 30h
	mov bh , 0
	
	add ax , bx
	mov word[num], ax
	jmp read_loop

end_read:

	popa
ret

;Function to print a number
print_num:
	pusha
	mov byte[count] , 0

extract_num:
	inc byte[count]
	mov ax , word[num]
	mov dx , 0
	mov bx , 10
	div bx
	
	push dx	
	cmp ax , 0
	je print_no
	mov word[num]  , ax
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

	call new_line
	popa
ret


; Function to read an array
read_array:
	pusha
read_loop1:
	cmp eax , dword[n]
	je end_read1
	
	mov word[num] ,0
	call read_num
	
	mov cx , word[num]
	mov word[ebx + 2 * eax] , cx
	inc eax
	
	jmp read_loop1

end_read1:
	popa
ret

; Function to print an array
print_array:
	pusha

print_loop1:
	cmp eax , dword[n]
	je end_read1
		
	mov cx , word[ebx + 2 * eax]
	mov word[num] , cx
	
	call print_num
	inc eax
	
	jmp print_loop1

end_print1:
	call new_line
	popa
ret

; Initialization
section .data
msg1 : db 'Enter the size of the first array ',0ah
len_msg1 : equ $- msg1

msg2 : db 'Enter the elements of the array',0ah
len_msg2 : equ $- msg2

msg3 : db 'Not Prime',0ah
len_msg3 : equ $- msg3 

msg4 : db 'Enter a element to find kth Largest  element in an array',0ah
len_msg4 : equ $- msg4

msg5 : db 'Enter a element to search in an array',0ah
len_msg5 : equ $- msg5
newline : db 10

msg6 :db 'Element Not Found',0ah
len_msg6 : equ $- msg6

msg7 : db 'Enter the size of the second array ',0ah
len_msg7 : equ $- msg7


; Variable Declaration 
section .bss

count : resb 1
temp  : resb 1
n     : resd 1
num   : resd 1
arr   : resw 50
l     : resd 1
num1  : resd 1
num2  : resd 1
num3  : resd 1
num4  : resd 1
max   : resd 1
min   : resd 1
num_  : resd 1
sum   : resd 1
k     : resd 1
start : resd 1
mid   : resd 1
end   : resd 1
str   : resw 50
n1    : resd 1
m     : resd 1
adr   : resd 1
adr1  : resd 1
adr2  : resd 1
x     : resd 1

; Main Function (int main)
section .text
global _start:
_start:

	mov eax , 4
	mov ebx , 1
	mov ecx , msg1
	mov edx ,len_msg1
	int 80h

	mov word[num] , 0
	call read_num
	mov ax , word[num]
	mov word[n1] , ax
	mov word[n] , ax 
	
	mov eax , 4
	mov ebx , 1
	mov ecx , msg2
	mov edx , len_msg2
	int 80h
	
	mov eax , 0
	mov ebx , arr
	call read_array
	
	mov eax , 4	
	mov ebx , 1
	mov ecx , msg7
	mov edx , len_msg7
	int 80h
	
	mov word[num] , 0
        call read_num
        mov ax , word[num]
        mov  word[m] , ax
        mov word[n] , ax

        mov eax , 4
        mov ebx , 1
        mov ecx , msg2
        mov edx , len_msg2
        int 80h

        mov eax , 0
        mov ebx , str
        call read_array

	mov ax , word[n]
	mov word[n] , ax
	mov eax , 0
	mov ebx , str
	call sort_array


	mov ax , word[n1]
	mov word[n] , ax
	mov eax , 0
	mov ebx ,arr
	call sort_array
		
	mov eax , arr
	mov ebx , str
	mov dword[adr1] ,eax
	mov dword[adr2] , ebx
	mov eax , 0

	mov ax , word[n1]
	mov word[n] , ax

	mov word[num1] , 0
	mov word[num2] , 0
	mov word[num3] , 0
	mov word[num4] , 0

	call new_line

	for_c1:
		mov eax , dword[num1]
		cmp eax , dword[n1]
		je exit
		
		mov ebx , dword[adr1]
		mov cx , word[ebx + 2 * eax]
		mov word[x] ,cx
		while_1:
		mov eax , dword[num1]
		mov cx ,word[x]
		mov dx ,cx

		mov cx , word[x]
		cmp cx , word[ebx + 2 * eax]
		je C_1
		jne C_2
	
	C_1:
	inc dword[num1]
	jmp while_1

	C_2:
	mov word[num] , dx
	mov eax , 0
	mov ebx , dword[adr2]
	mov cx , word[m]
	mov word[n] , cx

	call binary_Search	
	mov ax , word[num]
	
	cmp ax , 0
	je for_c1
	mov cx , word[x]
	mov word[num] , cx
	call print_num
	jmp for_c1


	call exit	
