read_num:
pusha
mov word[num], 0
loop_read:
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

inc byte[count]
mov dx, 0
mov ax, word[num]
mov bx, 10
div bx
push dx
mov word[num], ax
cmp ax, 0
je print_no
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
popa
ret

read_array:
pusha
read_loop:
cmp eax,dword[n]
je end_read1
call read_num
mov cx,word[num]
mov word[ebx+2*eax],cx
inc eax
jmp read_loop
end_read1:
popa
ret

print_array:
pusha
print_loop:
cmp eax,dword[n]
je end_print1
mov cx,word[ebx+2*eax]
mov word[num],cx
call print_num
inc eax
jmp print_loop
end_print1:
popa
ret

 section .data
  newline: db 10
  msg1: db 'NOT FOUND',0ah
   l1: equ $-msg1
     msg2: db 'FOUND',0ah
    l2: equ $-msg2
  
section .bss
temp: resb 1
count: resb 1
num: resw 1
array: resw 50
n: resd 1
x: resd 1
search: resd 1
mid: resd 1
low: resd 1
high: resd 1
counter: resd 1
x2: resd 1

section .text

global _start:
_start:

 
     call read_num
      mov cx,word[num]
      mov word[n],cx

       mov eax,0
       mov ebx,array
       call read_array

     mov eax,4
     mov ebx,1
     mov ecx,newline
    mov edx,1
    int 80h
   
    call read_num
       mov cx,word[num]
     mov word[search],cx

   
     mov dword[x],0
     mov ebx,array
              

        for:
         
              mov eax,dword[x]
            cmp eax,dword[n]
              jb  t1
               jmp label

              t1:          
          mov cx,word[ebx+2*eax]
             mov edx,eax
             add edx,1
           for1:
              
              cmp edx,dword[n]
                jb t2

                jmp label3

                  t2:
                 mov ax,word[ebx+2*edx]
                   cmp cx,ax
                     ja t3
                      jmp label2
                      
                   t3:
                   mov word[ebx+2*edx],cx
                   mov cx,ax
                  mov eax,dword[x]
                   mov word[ebx+2*eax],cx
                    mov cx,word[ebx+2*eax]
                  
                  label2:
                 inc edx
               jmp for1
              
             label3:
          inc dword[x]
       jmp for
  
 
         label:
       
    mov word[count] , 2
    mov word[low],0
    mov dx,word[n]
    dec dx
    mov word[high],dx
	
     mov eax,0
     mov ecx,array
          
      for2:
	mov ax,word[low]
	cmp ax,word[high]
	jna t4 
        jmp label6

       t4:
    	mov dx , 0
	mov ax , word[low]
        add ax,word[high]
  	mov bx ,word[count]
        div bx

        mov word[x2],ax

	mov ecx , array
        mov bx,word[search]
	mov eax , dword[x2]
        cmp bx,word[ecx+2*eax]
   	je t5
    	ja t6
	jmp t7
       
       t5:
        inc word[counter]
        jmp label4

       t6:
        mov dx,word[x2]
     	mov word[high],dx
        dec word[high]
       	jmp for2

        t7:
        mov dx,word[x2]
   	mov word[low],dx
        inc word[low]
	jmp for2

    label6:
    cmp word[counter],1
    je label4

    mov eax,4
    mov ebx,1
    mov ecx,msg1
    mov edx,l1
    int 80h
    jmp exit
 

    label4:
  
    mov eax,4
    mov ebx,1
    mov ecx,msg2
    mov edx,l2
    int 80h   
      

    exit:
     mov eax,1
     mov ebx,0
      int 80h


