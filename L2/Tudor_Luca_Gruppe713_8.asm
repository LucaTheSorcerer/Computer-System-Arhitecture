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
    a dw 0100101101011101b
    b dw 1001110101110100b
    c dd 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        ;I. die Bits 0-2 von C haben den Wert 0
        mov bx, 0 ;wir berechnen das ergebnis in bx --> bx = 0 |
        and bx, 0000000000000000b
        
        ;II. die Bits 3-5 von C haben den Wert 1
        or bx, 0000000000111000b ;wir wandeln din bits von 3-5 in bx in 1 um --> 0000000000111000
        
        ;III. die Bits 6-9 von C haben denselben Wert wie die Bits 11-14 von A
        mov ax, 0
        mov ax, [a] ;wir haben den wert von a in ax
        and ax, 0111100000000000b ;wir isolieren den bits 11-14 in ax --> 0100100000000000
        ror ax, 5 ;ax = 0000001001000000b
        or bx, ax ;bx = 0000001001111000b
        
        ;IV. die Bits 10-15 von C entsprechen den Bits 1-6 von B
        mov ax, 0; AX = 0
        mov ax, [b] ;in ax haben wir [b], also ax = 1001110101110100b
        and ax, 0000000001111110b ;wir isolieren die Bits 6-1 in [b] oder ax, also ax = 0000000001110100b
        rol ax, 9 ;wir machen ein Rotation nach links also die bits 6-1 in ax werden auf die Bitstellen 15-10 sein, also ax = 1110100000000000b
        or bx, ax ;wir verwenden die OR Operation damit die bits von ax in bx festgestellt werden --> bx = 1110101001111000b
        
        ;V. die Bits 16-31 von C haben den Wert 1
        mov cx, 1111111111111111b ;wir haben in cx nur die werte 1 also FFFF in hex
        rol ecx, 16 ;mit eine rotation nach links legen wir den bits von die Bitstellen 0-15 in CX auf die Bitstelle 16-31, ECX = FFFF 0000
        mov cx, bx ;wir legen den wert von bx in cx; CX = BX | ECX = FFFF EA78
        mov [c], ecx ;wir legen den wert von ecx in den doubleword [c] und erhalten das doppelword [c]
        
        
        
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
