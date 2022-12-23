bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit      
extern operation ;diese ist die Funcktion von die Datei "Tudor_Luca_713_4_function.asm"
extern printf, scanf    ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll 
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
global a1
global b1
global c1

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 0 ;wir definieren a, b und c als Byte
    b db 0
    c db 0
    
    a1 dd 0 ;wir werden die Variablen a, b bzw c in a1, b1 bzw c1 mit dem Datentyp Doublewort, so dass wir diese mit C Funktionen benutzen konnen
    b1 dd 0
    c1 dd 0
    format db "%u", 0 ;unsere zahlen sind vorzeichnlose also wir benutzen %u
    message_a db "a = ", 0
    message_b db "b = ", 0
    message_c db "c = ", 0
    format_result db "a - b + c = %d", 0 ;man benutzt format_result, um die Ergebnis auf den Bildschirm zeigen zu konnen

    debugging db "It works", 0
    
    

; our code starts here
segment code use32 class=code
    start:
        mov al, [c]
        mov ah, 0
        mov dx, 0
        push dx
        push ax
        pop eax
        mov ecx, eax ;wir wandeln a von ein byte in ein Doubleword
        mov [c1], ecx ;man speichert den Wert von ecx in c1
        
        mov eax, 0
        
        mov al, [b]
        mov ah, 0
        mov dx, 0
        push dx
        push ax
        pop eax
        mov ebx, eax ;wir wandeln b von ein byte in ein Doubleword
        mov [b1], ebx ;man speichert den Wert von ebx in b1
        
        mov eax, 0
        
        mov al, [a]
        mov ah, 0
        mov dx, 0
        pop eax ;wir wandeln c von ein byte in ein Doubleword
        mov [a1], eax ;man speichert den Wert von eax in a1
        
        
        push dword message_a ;man legt message_a auf de Stack
        call [printf] ;man ruft die Funktion printf, so dass man message_a auf den Bildschirm zeigen kann
        add esp, 4 ;man loscht die Paramters auf den Stack
        
        push dword a1 ;man legt a1 auf den Stack
        push dword format ;man legt den Format auf den Stack
        call [scanf] ;man ruft die Funktion scanf, so dass man input from User bekommen kann
        add esp, 4 * 2 ;man loscht die Paramters auf den Stack
        
        
        
        push dword message_b ;man legt message_b auf de Stack
        call [printf] ;man ruft die Funktion printf, so dass man message_b auf den Bildschirm zeigen kann
        add esp, 4 ;man loscht die Paramters auf den Stack
        
        
        push dword b1 ;man legt b1 auf den Stack
        push dword format ;man legt den Format auf den Stack
        call [scanf] ;man ruft die Funktion scanf, so dass man input from User bekommen kann
        add esp, 4 * 2 ;man loscht die Paramters auf den Stack
        
        push dword message_c ;man legt message_c auf de Stack
        call [printf] ;man ruft die Funktion printf, so dass man message_c auf den Bildschirm zeigen kann
        add esp, 4 ;man loscht die Paramteres auf den Stack
        
        push dword c1 ;man legt c1 auf den Stack
        push dword format ;man legt den Format auf den Stack
        call [scanf] ;man ruft die Funktion scanf, so dass man input from User bekommen kann
        add esp, 4 * 2 ;man loscht die Paramters auf den Stack
        
        push dword [c1] ;man legt c1, b1 und a1 auf den Stack
        push dword [b1]
        push dword [a1]
        call operation ;man ruft die Funktion operation von die Datei Tudor_Luca_713_4_function.asm 
        add esp, 4 * 3 ;man loscht die Paramters auf den Stack
        
        
        ;====================================
        ;Commands to transform the files into .obj and to link the .obj files together and then run the program
        ;nasm.exe -fobj Tudor_Luca_713_4_modul.asm
        ;nasm.exe -fobj Tudor_Luca_713_4_function.asm
        ;alink.exe Tudor_Luca_713_4_modul.obj Tudor_Luca_713_4_function.obj -oPE -subsys console -entry start
        ;Tudor_Luca_713_4_modul.exe
        ;====================================
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
