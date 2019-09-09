sum_digits:
        pusha
        mov word[sum] , 0
        for_sum:
                cmp word[num] , 0
                je end_for_sum
                mov dx , 0
                mov ax , word[num]
                mov bx , 10
                div bx

                mov word[num] , ax
                mov ax , word[sum]
                add ax , dx
                mov word[sum] , ax
                jmp for_sum

end_for_sum:
        popa
ret





