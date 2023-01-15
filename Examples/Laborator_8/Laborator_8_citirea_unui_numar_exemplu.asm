;Codul de mai jos va afisa mesajul "n=", apoi va citi de la tastatura valoarea numarului n.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
extern printf
extern scanf
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    n dd 0 ;in aceasta variabila se va stoca valoarea citita de la tastatura
           ;sirurile de caractere sunt de tip byte
    message db "n = ", 0 ;sirurile de caractere pentru functiile C trebuie sa se termine cu valoarea 0 (nu caracterul)
    format db "%d", 0 ;%d <=> un numar decimal (baza 10)

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;vom apela functia printf(message) => se va afisa "n = "
        ;punem parametrii pe stiva
        push dword message
        call [printf]
        add esp, 4 * 1
        
        ;vom apela functia scanf(format, n) => se va citi un numar in variabila n
        ;punem parametrii pe stiva de la dreapta la stanga
        push dword n
        push dword format
        call [scanf]
        add esp, 4 * 2
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
