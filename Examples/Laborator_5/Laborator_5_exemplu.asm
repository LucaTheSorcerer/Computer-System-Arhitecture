;Se da un sir de caractere format din litere mici
;Sa se transforme acest sir in sirul literelor mari corespunzatoare
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    sir db 'a', 'b', 'c', 'm', 'n' ;declaram sirul initial s
    l equ $-sir                      ;stabilim lungimea sirului initial sir si salvam in l
    d times l db 0 ;rezervarea unui spatiu de dimensiune l pentru sir destinatie d si initializarea acestuia

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, l ;punem lungimea in ECX pentru a putea realiza bucla de ecx ori
        mov esi, 0
        jecxz Sfarsit ;daca ecx = 0, se face un salt la label-ul Sfarsit
        Repeta:
            mov al, [sir + esi]
            mov bl, 'a' - 'A' ;pentru a obtine litera mare corespunzatoare literei mici, vom scadea din codul ASCII
            sub al, bl
            mov [d + esi], al
            inc esi
        loop Repeta
        Sfarsit: ;aici se incheie termina programul
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
