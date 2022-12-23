bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit      
extern operation
;extern user_input    
extern printf, scanf    ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll 
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
global a1
global b1
global c1

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 0
    b db 0
    c db 0
    
    a1 dd 0
    b1 dd 0
    c1 dd 0
    result dd 0
    format db "%u", 0
    message_a db "a = ", 0
    message_b db "b = ", 0
    message_c db "c = ", 0
    format_result db "a - b + c = %d", 0

    debugging db "It works", 0
    
    

; our code starts here
segment code use32 class=code
    start:
        mov al, [a]
        mov ah, 0
        mov dx, 0
        push dx
        push ax
        pop eax
        mov ecx, eax
        mov [c1], ecx
        
        mov eax, 0
        
        mov al, [b]
        mov ah, 0
        mov dx, 0
        push dx
        push ax
        pop eax
        mov ebx, eax
        mov [b1], ebx
        
        mov eax, 0
        mov al, [a]
        mov ah, 0
        mov dx, 0
        pop eax
        mov [a1], eax
        
        
        
       
        
        
        push dword message_a
        call [printf]
        add esp, 4
        
        push dword a1
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        
        
        push dword message_b
        call [printf]
        add esp, 4
        
        
        push dword b1
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        push dword message_c
        call [printf]
        add esp, 4
        
        push dword c1
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        push dword [c1]
        push dword [b1]
        push dword [a1]
        call operation
        add esp, 4 * 3
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
