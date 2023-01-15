bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "personal_data.txt", 0
    acces_mode db "r", 0
    file_descriptor dd -1
    len equ 100
    text times (len + 1) db 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;folosim functia fopen pentru a deschide fisierul personal_data.txt
        ;in eax vom avea file_descriptor-ul fisierului
        ;eax = fopen(file_name, acces_mode)
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax
        
        ;folosim functia fread pentru a citi continutul fisierului
        ;fread(text, 1, len, file_descriptor)
        ;in eax va fi stocat numarul de caractere citite
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        ;folosim functia printf pentru a arata pe ecran continutul din variabila text
        ;printf(text)
        push dword text
        call [printf]
        add esp, 4
        
        
    final:
        ;folosim functia fclose pentru a inchide fisierul
        ;fclose(file_descriptor)
        push dword file_descriptor
        call [fclose]
        add esp, 4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
