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
    sir1 db 1, 3, 6, 2, 3, 7 ;man deklariert din Zeichenfolge sir1 von Bytes
    sir2 db 6, 3, 8, 1, 2, 5 ;man deklariert din Zeichenfolge sir2 von Bytes
    l equ $-sir2 ;man berechnet die Lange der Zeichenfolge sir2 in l
    d times l db 0 ;man reserviert l Bytes fur den Zeichenfolge d und initialisiert ihn

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0 ;wir machen alle Registern 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        mov esi, 0
        
        while1:
        cmp esi, l ;wir machen eine cmp zwischen esi und l
        je end_while1 ;wenn diese beide gleich sind, dann es bedeutet, dass wir am ende den Zeichenfolge sind und wir mussen den while loop enden
        mov al, [sir1 + esi] ;wir legen das Element 0 + Wert von Esi von sir1 in al, al = 1, al = 3 usw 
        mov bl, [sir2 + esi] ;wir legen das Element 0 + Wert von Esi von sir2 in bl, bl = 6, bl = 3 usw
        cmp al, bl ;wir machen ein cmp zwischen al und bl
        jg bigger ;wenn al grosser als bl ist dann benutzen wir ein jg zum bigger
        mov [d + esi], bl ;wenn bl grosser als al ist, dann legen wir den wert von bl in d + esi also erste element in der neue Zeichenfolge; In d haben wir den wert von bl, zum beispiel 6
        mov cl, bl ;wir speichern bl in cl so dass wir uberprufen konnen ob das grossere Element in d gespeichert ist
        jmp not_bigger
        bigger:
        mov [d + esi], al ;wir speichern al in d + esi
        mov cl, al ;wir speichern al in cl, so dass wir uberprufen konnen, ob das grossere Element in d gespeichert ist
        not_bigger:
        inc esi ;wir incrementieren esi, so dass wir den nachste elemente von sir1 und sir2 analysieren zu konnen
        jmp while1
        end_while1:
        
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        mov esi, 0
        while2: ;wir uberprufen ob alle werten von d korrekt sind
        cmp esi, l ;cmp zwischen esi un die Lange von l
        je end_while2 ;wenn diese gleich sind, dann muss das while loop enden
        mov al, [d + esi] ;wir speichern den Wert d + esi in al, al = 6, al = 3, al = 8 usw
        inc esi ;wir incrementieren esi so dass wir den nachste Element von dspeichern konnen
        jmp while2
        end_while2:
        
        
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
