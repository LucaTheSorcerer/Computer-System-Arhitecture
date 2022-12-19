bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    a db 1
    b dw 0
    c dd 3
    x dq 8
    ; ...

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;14. fara semn x+(2-a*b)/(a*3)-a+c
        mov eax, 0 ;wir machen all registers 0, so dass wir keine andere werten haben
        mov ebx, 0 ; EAX = 0, EBX = 0, ECX = 0, EDX = 0
        mov ecx, 0
        mov edx, 0
        
        ;a) (2-a*b) start --> BX = 2
        mov al, [a] ;AL = 1
        mov ah, 0 ; AH = 0 --> AX = 0001, AH = 00, AL = 01
        mov bx, [b]; BX = 0
        mul bx ; DX:AX = AX*BX, Ergebnis in AX, 16 bits, wir werden in AX den Wert 0 haben und in DX auch 0; wir haben unsere wert in DX:AX -> DX = 0 AX = 0
        mov bx, 2 ; BX = 2
        sub bx, ax; BX = BX - 0 = 2 - 0 = 2 --> BX = 2
        ;end a)
        
        ;b) (a*3) start --> AX = 3
        mov al, 3 ; AL = 3
        mul byte[a] ;AX = AL * [A] --> AX = 3 * 1 --> AX = 3
        ;b) end
        
        ;c) (2-a * b)/(a * 3) --> AX = 0, DX = 2; Wir brauchen nur die AX Register
        mov cx, ax; CX = AX --> CX = 3
        mov ax, bx; AX = BX --> AX = 2
        mov dx, 0; DX = 0  und AX = 2 --> DX:AX = 0:2
        mov bx, cx; BX = CX --> BX = 3
        div bx ; BX = DX:AX / BX = 0:2 / 3; AX = 0, DX = 1
        ;c) end
        
        ;d) (2-a*b)/(a*3)-a+c; AX - a + c
        push dword [c] ;wir wollen dann zuerst ax mit c addieren und dann mit a subtrachieren, so dass wir nicht ein -1 mehr erhalten; wir legen [c] auf den stack also esp zeigt hier
        pop bx ;wir  bx nimmt die ersten bits auf den stack
        pop cx ;wir nehmen cx auf den stack CX = 0
        mov dx, 0 ;DX wird 0 sein
        add ax, bx; AX = AX + BX  = 0 + 3 --> AX = 3
        adc dx, cx; DX = DX + CX CARRYFLAG, wenn es gibt
        mov bl, [a]; BL = [a] = 1
        mov bh, 0 ; BH = 0 --> BX = 1
        sub ax, bx ;AX = AX - BX = 3 - 1 = 2
        push dx ;wir legen dx auf den stack, also ESP zeigt hier
        push ax ;wir legen ax auf den stack, also ESP zeight hier
        pop eax ;wir nehmen eax auf den stack und eax wird 2 sein, wir brauchen EAX so dass wir diese wert mit dem quadword x addieren konnen. Also zum Beispiel EBX:ECX + EDX:EAX
        ;d) end
        
        ;e)x+(2-a*b)/(a*3)-a+c --> x + DX:AX
        ; EBX: ECX
        mov ecx, [x+0] ;ECX = 0008 --> wir legen den quadword x auf EBX:ECX. also in zwei teilen weil es 64 bits enthalt
        mov ebx, [x+4] ;EBX = 0000
        ; EDX:EAX
        mov edx, 0 ; EDX = 0000, EAX = 0002 --> wir machen EDX = 0, so dass wir den doubleword eax in den quadword EDX:EAX umwandeln konnen
        
        clc ;wir loschen den carryglag, wenn werten in die register schon sind, so dass wir nicht zufallige Werten haben
        add ecx, eax; ECX = ECX + EAX --> ECX = 0008 + 0002 = A (10) --> unsere Ergebnis wird in ECX gespeichert
        adc edx, ebx; EDX = EDX + EBX + CF --> EDX = 0000 + 0000 + CF (wenn es ein CF gibt) --> unsere CF (wenn es gibt) wird in EDX gespeichert
        ;EBX:ECX + EDX:EAX = EDX:ECX
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
