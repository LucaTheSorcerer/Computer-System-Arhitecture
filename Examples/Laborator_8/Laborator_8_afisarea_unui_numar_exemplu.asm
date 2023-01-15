;Codul de mai jos va afisa mesajul "Ana are 17 mere"
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
extern printf
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    format db "Ana are %d mere", 0 ;%d va fi inlocuit cu un numar
                                   ; sirurile de caractere pt functiile C trebuie terminate cu valoarea 0
    numar_mere dd 18
    format1 db "Luca are %d mere", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 17
        
        ;vom apela printf(format, 17) => se va afisa: "Ana are 17 mere"
        ;punem parametrii pe stiva de la dreapta la stanga
        
        push dword eax
        push dword format ;! pe stiva se pune adresa string-ului, nu valorea
        call [printf]     ;apelam functia printf pentru afisare
        add esp, 4 * 2    ;eliberam parametrii de pe stiva; 4 = dimensiunea unui dword
                          ; 2 = nr de parametri
                          
        push dword [numar_mere]
        push dword format1
        call [printf]
        add esp, 4 * 2
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
