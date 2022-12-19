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
    b dd 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;I. die Bits 28-31 von B haben den Wert 1
        mov eax, 0; wir berechnen unsere Ergebnis in EAX, EAX = 0
        or eax, 11110000000000000000000000000000b ;EAX = 11110000000000000000000000000000b; wir legen die Wert 1 fur die Bits 28-31
        
        ;II. die Bits 24-25 und 26-27 von B sind die gleichen wie die Bits 8-9 von A
        ;a) die Bits 24-25 von B sind die gleichen wie die Bits 8-9 von A
        mov ebx, 0 ;EBX = 0bits 32 ; assembling for the 32 bits architecture
        mov bx, [a]; EBX = 00000000000000000100101101011101b
        and ebx, 00000000000000000000001100000000b ;EBX = 00000000000000000000001100000000b
        rol ebx, 16 ;EBX = 00000011000000000000000000000000b - Rotation nach links mit 16 Bitstelle
        or eax, ebx ; EAX = 11110011000000000000000000000000b - wir legen den bits auf position 24-25 von ebx in eax mit OR
        
        ;b) die Bits 26-27 von B sind die gleichen wie die Bits 8-9 von A
        rol ebx, 2 ;EBX = 00001100000000000000000000000000b ;Rotation nach links mit 2 Bitstelle so dass wir den bits von 24-25 zu 26-27 Bitstelle bringen konnen
        or eax, ebx ; EAX = 11111111000000000000000000000000b - Legen den bits 26-27 von EBX in EAX
        
        ;III. die Bits 20-23 von B sind die Invertierung der Bits 0-3 von A
        mov ebx, 0
        mov bx, [a] ;EBX = 00000000000000000100101101011101b
        not ebx      ;EBX = 11111111111111111011010010100010b - Invertieren alle Bits
        and ebx, 00000000000000000000000000001111b ;EBX = 00000000000000000000000000000010b - Isolierien den Bits 0-3, die wir brauchen
        rol ebx, 20 ;EBX = 00000000001000000000000000000000b ;wir bringen den bits 0-3 an die Bitstellen 20-23 mit eine Rotation nach link mit 20 Bitstellen
        or eax, ebx ;EAX = 11111111001000000000000000000000b - legen die Bits von ebx in eax 
        
        ;IV. die Bits 16-19 von B haben den Wert 0
        or eax, 00000000000000000000000000000000b 
        
        ;V. die Bits 0-15 von B sind die gleichen wie die Bits 16-31 von B
        mov ebx, 0
        mov ebx, eax ;EBX = 11111111001000000000000000000000b
        and ebx, 11111111111111110000000000000000b ;EBX = 11111111001000000000000000000000b -Isolieren die Bits von die Wertstellen 16-31
        ror ebx, 16 ;EBX = 00000000000000001111111100100000b ;wir bringen die Bits 16-31 zu dem Bitstellen 0-15 mit einem Rotation nach rechts
        or eax, ebx; ;EAX = 11111111001000001111111100100000b ;legen die bits von ebx in eax 
        mov [b], eax ;wir speichern eax in [b] und haben unsere doubleword erhalten
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program