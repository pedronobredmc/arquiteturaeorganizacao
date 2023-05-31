            .686
            .model  flat, c
            .stack  100h
printf      PROTO   arg1:Ptr Byte, printlist:VARARG
scanf       PROTO   arg2:Ptr Byte, inputlist:VARARG
            .data
msg1fmt     byte   0Ah, "%s%d", 0Ah, 0Ah, 0
msg1        byte   "The contents of the accumulator are: ", 0
temp        sdword ?
three       sdword 3
            .code
LOADACC     macro operand
            mov eax, operand   ;; load eax with the operand
            endm
ADDACC      macro operand
            add eax, operand   ;; add the operand to eax 
            endm
SUBACC      macro operand
            sub eax, operand   ;; subtract the operand from eax
            endm
DIVACC      macro operand
            push ebx
            push ecx
            if operand LT 0
            neg operand
            endif
            if eax LE 0
            endm
            endif
            mov ebx, operand
            idiv ebx
            pop ecx
            pop ebx
            endm
STOREACC    macro operand
            mov operand, eax   ;; store eax in operand
            endm
MULTACC     macro operand
	        push ebx           ;; save ebx and ecx
            push ecx
            mov ebx, eax       ;; mov eax to ebx
            mov eax, 0         ;; clear accumulator to zero
            mov ecx, operand   ;; load ecx with operand
            if operand LT 0    ;; if operand is negative
            neg ecx            ;; make ecx positive for loop
            endif   
            .while ecx > 0
            add eax, ebx       ;; repetitively add 
            dec ecx            ;; decrement ecx
            .endw    
            if operand LT 0    ;; if operand is negative
            neg eax            ;; negate accumulator, eax
            endif
            pop ecx            ;; restore ecx and ebx
            pop ebx 
            endm
main        proc 
            LOADACC 2
            ADDACC 3
            DIVACC 2
            CALL    OUTACC
            ret
main        endp
OUTACC      proc
	        push eax           ;; save ebx and ecx, and edx
            push ecx
            push edx
            mov temp, eax
            INVOKE printf, ADDR msg1fmt, ADDR msg1, temp
	        pop edx            ;; save ebx and ecx, and edx
            pop ecx
            pop eax
            ret       
OUTACC      endp
INACC       proc
            push eax           ;; save ebx and ecx, and edx
            push ecx
            push edx
            INVOKE scanf, ADDR msg1fmt, ADDR msg1, ADDR temp
            mov eax, temp
            pop edx            ;; save ebx and ecx, and edx
            pop ecx
            pop eax
            ret
INACC       endp
            end  