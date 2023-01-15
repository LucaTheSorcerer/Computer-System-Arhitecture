;Zwei naturliche Zahlen a und b (Doppelworter im Datensegment definiert) werden gegeben. Berechne a/b und zeige den Quotient und den Rest im folgenden Format auf dem Bildschirm an: "Quotient = <Quotient>, Rest = <Rest>"
;Beispiel: a = 23, b = 10 wird Folgendes angezeigt: "Quotient = 2, Rest = 3"
;Die Werte werden im Dezimalformat mit Vorzeichen angezeigt
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
    a dd 30
    b dd 4
    format db "Quotient = %d, Rest = %d", 0 ;The format for the output

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        mov eax, [a]
        cdq
        mov ebx, [b]
        div ebx ; edx:eax / ebx --> eax = Quotient, edx = Rest
        
        ;we call printf(format, eax, edx)
        push dword edx
        push dword eax
        push dword format
        call [printf]
        add esp, 4 * 3
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
