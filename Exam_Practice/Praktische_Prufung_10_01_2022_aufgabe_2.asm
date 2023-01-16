bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern exit, gets, printf
import exit msvcrt.dll
import gets msvcrt.dll
import printf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    s db "Anajj j are mere", 0
    w times 181 db 0
    string_format db "%s with lenght %d", 0Ah, 0

; our code starts here
segment code use32 class=code
    start:
        mov esi, 0
        mov edi, 0
        
        while_go_through_s:
            push dword 0
            push dword s
            push dword string_format
            call [printf]
            add esp, 4*2
        
            mov al, [s + esi]
            cmp al, 0
            
            je final
            
            cmp al, ' '
            je newWord
            cmp al, '.'
            je newWord
            
            notNewWord:
                mov [w + edi], al
                inc edi
                
                inc esi
                jmp while_go_through_s
                
            newWord:
                cmp edi, 0
                ;je notPrint
                
                push dword edi
                push dword w
                push dword string_format
                call [printf]
                add esp, 4 * 2
                
                mov edi, 0
                
                notPrint:
                
                mov ecx, 251
                
                clear_w:
                    mov [w + ecx], byte 0
                    
                loop clear_w
                
                mov edi, 0
                
                inc esi
    jmp while_go_through_s
                
        
    final:
        cmp edi, 0
        je notPrint_final
                
        push dword w
        push dword string_format
        call [printf]
        add esp, 4 * 2
        
        mov edi, 0
                
        notPrint_final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
