;Lese zwei Zahlen a und b in der Basis 16 von der Tastatur und berechne a + b.
;Zeige das Ergebniss in Basis 16
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dd 0
    b dd 0
    hex_format db "%x", 0
    message_a db "a = ", 0
    message_b db "b = ", 0
    result_format db `a + b = %d \n`, 0
    result_format1 db "%d + %d = %d", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;folosim printf pentru a arata message_a pe ecran
        ;printf(message_a)
        push dword message_a
        call [printf]
        add esp, 4
        
        ;folosim scanf pentru a citi numarul a de la tastatura
        ;scanf(hex_format, a)
        push dword a
        push dword hex_format
        call [scanf]
        add esp, 4 * 2
        
        ;folosim printf pentru a arata message_b pe ecran
        ;printf(message_b)
        push dword message_b
        call [printf]
        add esp, 4
        
        ;folosim scanf pentru a citi numarul b de la tastatura
        ;scanf(hex_format, b)
        push dword b
        push dword hex_format
        call [scanf]
        add esp, 4 * 2
        
        ;facem adunarea a + b si o salvam in eax
        mov eax, [a]
        add eax, [b]
        
        ;folosim functia printf pentru a afisa pe ecran result_format si rezultatul adunarii din eax
        ;printf(result_format, eax)
        push dword eax
        push dword result_format
        call [printf]
        add esp, 4 * 2
        
        mov ebx, 0
        mov ebx, [a]
        add ebx, [b]
        
        ;printf(result_format1, a, b, ebx)
        push dword ebx
        push dword [b]
        push dword [a]
        push dword result_format1
        call [printf]
        add esp, 4 * 4
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
