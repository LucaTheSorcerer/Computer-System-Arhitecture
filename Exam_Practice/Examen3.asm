bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
extern printf
extern fopen
extern fclose
extern scanf
extern fprintf
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "output.txt", 0
    mod_acces db "w", 0
    descriptor_fisier dd -1
    n dd 0 ;we save the value that we read from the keyboard as input
    numar db "numar = ", 0 ;the message that we want to display on the screen before reading number
    format db "%d", 0 ;formatul pentru un numar decimal in baza 10
    format_string db "%s", 0
    caracter_spatiu db " ", 0
    zece dw 10
    exists db 0
    keine db "Keine Zahl", 0
    formats db "%s", 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        ;we use fopen to open the file and if it does not exist the "w" will create it
        ;eax = fopen(file_name, mod_acces)
        push dword mod_acces
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        cmp eax, 0
        je final
        
        mov [descriptor_fisier], eax
        
        
        while_read_input_from_user:
           ; we compare edx with the value in n in order to see if we read a 0
            
            ;we use printf to print numar to the screen
            push dword numar
            call [printf]
            add esp, 4
            
            ;we use scanf to read a number from file
            ;scanf(format, n)
            push dword n
            push dword format
            call [scanf]
            add esp, 4 * 2
            
            mov edx, 0
            cmp [n], edx
            je end_while_read_input_from_user
            
            mov eax, [n]
            mov ebx, 0 ; in ebx facem suma
            
            sum_of_digits:
                mov edx, 0 ; am impartitorul pe edx:eax
                mov ecx, 10
                div ecx
                add ebx, edx
                cmp eax, 0
                je sum_is_ready
            jmp sum_of_digits
            
            sum_is_ready:
                cmp ebx, 15
                jl not_good
                
                mov eax, ebx
                mov edx, 0
                mov ecx, 3
                div ecx
                cmp edx, 0
                jne not_good
                
                mov [exists], byte 1
                
                push dword [n]
                push dword format
                push dword [descriptor_fisier]
                call [fprintf]
                add esp, 4 * 3
            
                push dword caracter_spatiu
                push dword format_string
                push dword [descriptor_fisier]
                call [fprintf]
                add esp, 4 * 3
            
            not_good:
            
        jmp while_read_input_from_user
        
        end_while_read_input_from_user:
    final:
        ;we use the function fclose to close the file
        ;fclose(descriptor_fisier)
        mov bl, [exists]
        cmp bl, 0
        jne end
        push dword keine
        push dword formats
        push dword [descriptor_fisier]
        call [fprintf]
        add esp, 4*3
        
        end:
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 4
    
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program