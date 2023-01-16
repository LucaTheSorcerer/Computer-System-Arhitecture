bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fprintf, fclose, fopen               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import fopen msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;variabile necesare pentru printarea pe ecran a unui mesaj
    mesaj db "Iubesc ASC ", 0
    format_n db "n = %d", 0
    n dd 7 ;variabila ce apare pe ecran
    ;==========================================================
    
    ;variabile necesare pentru a citi un numar de la tastatura
    numar dd 0
    format_numar db "%d", 0
    ;==========================================================
    
    ;variabile necesare pentru creare fisier
    nume_fisier db "luca.txt", 0
    mod_acces db "w", 0
    descriptor_fisier dd -1
    ;=========================================
        

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;cod pentru printarea pe ecran fara valoare
        ;functia printf(mesaj)
        push dword mesaj
        call [printf]
        add esp, 4
        
        ;cod pentru printarea pe ecran cu valoare
        ;functia printf(format_numar, n)
        push dword [n]
        push dword format_n
        call [printf]
        add esp, 4 * 2
        
        
        ;cod pentru citirea unui parametru de la tastatura
        ;functia scanf(format_numar, numar)
        push dword numar
        push dword format_numar
        call [scanf]
        add esp, 4 * 2
        
        
        ;cod pentru crearea unui fisier
        ;functia va returna in eax descriptorul fisierului sau 0 in caz de eroare
        ;eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2
        
        cmp eax, 0
        je final
        
        mov [descriptor_fisier], eax
        
        ;cod pentru a scrie un text intr-un fisier
        ;fprintf(descriptor_fisier, mesaj)
        push dword mesaj
        push dword [descriptor_fisier]
        call [fprintf]
        add esp, 4 * 2
        
        ;cod pentru a scrie un text citit de la tastatura in fisier
        ;printf(descriptor_fisier, format, [numar])
        push dword [numar]
        push dword format_numar
        push dword [descriptor_fisier]
        call [fprintf]
        add esp, 4 * 3
        
        ;cod pentru a citi dintr-un fisier un fisier
        ;functia fread(buffer, 1, len, descriptor_fisier)
        ;buffer times (len + 1) db 0
        ;len equ 100
        
        
        ;cod pentru a inchide un fisier
        ;fclose(descriptor_fisier)
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 4
        
        
    final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
