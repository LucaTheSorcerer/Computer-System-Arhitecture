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
    a dw -2
    b db -2
    c db -4
    d db -2
    e dd -1
    x dq -4

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;4. cu semn (a*2+b/2+e)/(c-d)+x/a
        
        ;a) a*2 start --> AX = -4 --> CX = -4
        mov eax, 0 ;wir machen 0 alle register, die wir brauchen, so dass wir keine zufallige Werten haben
        mov edx, 0 ; EAX = 0, EDX = 0, EBX = 0
        mov ebx, 0
        mov ax, [a] ;AX = -2, wir legen [a] in AX, weil [a] ein Word ist
        mov ah, 2 ;AH = 2
        imul ah ;AX = AX * AH = (-2) * 2 = -4
        mov ecx, 0 ;ECX = 0
        mov CX, AX; CX = AX --> CX = -4
        ;a) end
        
        ;b) b/2 start --> AX = -5
        mov al, [b] ;AL = [B] = -2
        cbw; AX = -2 (wir wandeln al in ein word, so dass wir mit ein byte teilen konnen; also es wird AX sein)
        mov bl, 2 ;BL = 2
        idiv bl ; AX = AX / BL --> AX = (-2) / 2 = -1 --> AL = -1
        cbw ;AL ist ein byte und wir wandeln es in ein Word um, also AL --> AX = -1
        add ax, cx ; AX = AX + CX --> AX = (a*2) + (b/2) --> AX = (-4) + (-1) --> AX = -5
        ;b) end
        
        ;c)(a*2+b/2+e)
        cwd ;wir wandeln ax in ein doubleword, so dass wir dann mit (c-d) dividieren und mit e addieren konnen, die wir spater in ein word umwandeln werden --> AX = DX:AX = -1 : -5
        mov bx, word [e] ; [e] ist ein doubleword also wir legen es auf zwei registern, BX, CX --> BX = -1
        mov cx, word [e+2] ; CX = -1 --> CX:BX
        ;wir addieren DX:AX MIT CX:BX
        add ax, bx ; AX = AX + BX --> AX = -5 + (-1) = -6
        adc dx, cx ; DX = CARRY FLAG DX + CX --> DX = -1
        ;c) end
        
        ;d) (c-d) start --> BL = -2
        mov bl, [c] ;BL = [C] = -4
        sub bl, [d] ; BL = BL - [D] = -4 - (-2) = -2 --> BL = -2
        ;d) end
        
        ;e) (a*2+b/2+e)/(c-d) start --> DX:AX / BL --> AX = 3
        mov cx, ax ; wir mochten den register ax frei machen, so dass wir BL (c-d) in ein Word umwandeln konnenCX; AX --> DX:CX
        mov al, bl ; wir legen BL in AL; AL = BL = -2
        cbw ;wir wandeln BL in ein Word um, so dass wir es mit dem double word DX:AX teilen konnen --> es wird BX sein --> AX = -2
        mov bx, ax; wir legen AX in BX --> BX = -2
        mov ax, cx ;wir legen CX IN AX also wir konnen DX:AX mit BX teilen --> AX = -6
        idiv bx; DX:AX / BX --> (-6) / (-2) = 3 --> AX = 3
        push dx ;ESP zeigt hier auf den Stack
        push ax ;ESP zeigt hier auf den Stack
        pop ebx ;wir wollen DX:AX in EBX haben, so dass wir mit den quadqword x einfacher addieren konnen --> EBX = 3
        ;e) end
        
        ;f) x/a start
        ;EDX:EAX =
        mov ax, [a] ;wir legen [a] in AX --> AX = -2
        cwde ;wir wandeln AX in ein doubleword, so dass wir den quadword x mit cx teilen konnen und mit cwde wir AX in EAX umwandeln konnen
        mov ecx, eax ;wir legen EAX in ECX, weil wir EAX frei fur den quadword x haben mochten
        mov eax, dword [x]; EAX = -4
        mov edx, dword [x+4]; EDX = -1
        idiv ecx ; wir teilen EDX:EAX mit ECX --> -1:-4 / -2 --> EAX = -4 / -2 = 2
        
        ;g)(a*2+b/2+e)/(c-d)+x/a
        add eax, ebx ;wir addieren die Ergebnisse von EAX, bzw. EBX --> EAX = EAX + EBX = 2 + 3 = 5
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
