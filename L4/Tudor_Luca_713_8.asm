bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    format db "%d * %d = %d", 0
    a dd -4
    b dd -5
    result dq 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, [a] ;wir speichern a in eax, also eax = 4
        mov ecx, eax ;wir speichern eax in ecx, so dass wir den wert von a before der Multiplikation haben, also ecx = eax = 4
        mov ebx, [b] ;wir speichern b in ebx, alsi ebx = 5
        imul ebx ;wir multiplizieren eax mit ebx; und wir werden den wert in edx:eax haben = 20
        mov [result+0], eax ;wir speichern unsere Ergebniss in result
        mov [result+4], edx
        mov [b], ebx
        mov [a], ecx
        push dword [result] ;wir legen result auf den stack
        push dword [b] ;wir legen b auf de stack
        push dword [a] ;wir legen a auf den stack
        push dword format ;wir legen auch den format auf den stack
        call [printf] ;wir rufen die Function printf an, so dass wir unsere Ergebnisse auf den Bildschrim zeigen konnen
        add esp, 4*4 ;wir loschen die Paramtere auf den stack
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
