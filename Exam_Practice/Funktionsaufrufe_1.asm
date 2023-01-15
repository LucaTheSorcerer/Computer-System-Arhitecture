bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
extern printf, scanf ;add printf and scanf as extern functions 
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    number1 dd 0 ;
    number2 dd 0
    message1 db "number1 = ", 0
    message2 db "number2 = ", 0
    format db "%d", 0
    result dq 0;

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword message1
        call [printf]
        add esp, 4*1
        
        push dword number1
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        push dword message2
        call [printf]
        add esp, 4 * 1
        
        push dword number2
        push dword format
        call [scanf]
        add esp, 4 * 2
        
        mov eax, 0
        mov edx, 0
        mov ebx, 0
        mov ecx, 0
        mov eax, [number1]
        mov ebx, [number2]
        imul ebx
        mov [result+0], eax
        mov [result+4], edx
        
        push dword [result]
        push dword format
        call [printf]
        add esp, 4
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
        