;Programul de mai jos va calcula rezultatul unor operatii aritmetice in registrul eax, va salva valoarea registrilor, apoi va afisa valoarea rezultatului si va restaura valoarea registrilor
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ; sirurile de caractere sunt de tip byte
    format db "%d", 0 ;%d <=> un numar decimal (baza 10)

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;vom calcula 20 + 123 + 7 in EAX
        mov eax, 20
        add eax, 123
        add eax, 7 ;eax = 150 in baza 10
        
        ;salvam valoarea registrilor deoarece apelul functiei sistem printf va modifica valoarea acestora
        ;folosim instructiunea PUSHAD care salveaza pe stiva valorile mai multor registrii printre care EAX, ECX, EDX si EBX
        ; in acest exemplu este important sa salvam doar valorea registrului EAX, dar instructiunea poate fi aplicata generic
        PUSHAD
        
        ;vom apela print(format, eax) => vom afisa valoarea in eax
        ;punem parametrii pe stiva de la dreapta la stanga
        push dword eax
        push dword format
        call [printf]
        add esp, 4 * 2
        
        ;dupa apelul functiei printf registrul eax are o valoare setata de aceasta functie (nu valorea 150 pe care am calculat-o la inceputul programului)
        ;restauram valoarea registrilor salvati pe stiva la apelul instructiunii PUSHAD folosind instructiunea POPAD
        ;aceasta instructiune ia valori de pe stiva si le completeaza in mai multi registrii printr care EAX, ECX, EDX si EBX
        ;este important ca inaintea unui apel al instructiunii POPAD sa ne asiguram ca exista suficiente valori
        ;pe stiva pentru a fi incarcat in registrii
        
        POPAD
        
        ;acum valorea registrului eax a fost restaurata la valorea de dinaintea apelului instructiunii PUSHAD 
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
