 for1:

                cmp eax , dword[n]
                je exit
                mov ebx , array
                mov cx , word[ebx + 2 * eax]
                mov word[save1] , cx
                inc eax
                mov ecx , 0 
                mov word[save] , 0
                mov word[num1] , 0




 L1:
                inc word[num1]
                jmp for2

        for2_end:
                mov bx , word[num1]
                cmp  bx , word[num2]
                ja L2
                jmp exit
        L2:
        mov word[num2] , bx
        mov ebx , array 
        mov bx , word[ebx + 2 * eax]
        mov word[num3] , bx
        jmp exit

