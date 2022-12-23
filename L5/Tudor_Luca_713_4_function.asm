bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
        
global operation
; declare external functions needed by our program
extern exit, scanf, printf            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import scanf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
extern a1, b1, c1 ;Diese Variablen kommen von die Datei Tudor_Luca_713_4_modul.asm, wo sie als global declariert wurden
segment data use32 class=data
    ; ...

    format_result db "a - b + c = %d", 0 ;this is how our result will look like
    result dd 0
    

    
; our code starts here
segment code use32 class=code
        ; ...
    
    ;Man benutzt diese Funktion um a-b+c zu rechnen
    operation:
        
        mov eax, [a1] ;man speichert a1 in eax
        sub eax, [b1] ;man subtrachiert b1 von eax
        add eax, [c1] ;man addiert c1 zum eax
        ;mov [result], eax ;man speichert eax in result
        
        push dword eax ;man legt eax auf dem Stack
        push format_result ;man legt das format auf den Stack
        call [printf] ;man ruft den Function printf so dass man die Ergebnis auf den Bilschrim zeigen kann
        add esp, 4 ;man loscht die Paramters auf den Stack
        
    ret
        
        
    
