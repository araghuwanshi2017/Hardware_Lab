read_num:
pusha
mov word[num] , 0
loop_read:

	mov eax , 3
	mov ebx , 0
	mov ecx , temp
	mov edx , 1
	int 80h
	
	cmp byte[temp] , 10
	je end_read
	
	mov ax , word[num]
	mov bx ,10
	mul bx

	mov bl , byte[temp]
	sub bl , 30h
	mov bh , 0
	add ax , bx
	mov word[num],ax
	jmp read_loop

end_read:
	popa
	ret

	
print_num:
mov byte[count] , 0
pusha

extract_num:
	inc byte[count] 
	mov dx , 0
	mov ax , word[num]
	mov bx , 10
	div bx
	push dx
	cmp ax , 0
	je print_no
	mov word[num], ax
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
	mov edx, 1
	int 80h
	
popa
ret`
	
