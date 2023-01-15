;Codul de mai jos va deschide un fisier numit "ana.txt" din directorul curent si va citi un text de maxim 100 de caractere din acel fisier
;Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru citirea din fisier si functia fclose pentru inchidierea fisierului deschis
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    nume_fisier db "ana.txt", 0 ;numele fisierului care va fi deschis
    mod_acces db "r", 0 ;modul de deschidere a fisierului
                        ; r - pentru citire, fisierul trebuie sa existe
    descriptor_fisier dd -1 ;variabila in care vom salva descriptorul fisierului - necesar pentru a face referire la fisier
    len equ 100 ;numarul maxim de elemente citite din fisier
    text times len db 0 ;sirul in care se va citi textul din fisier
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;apelam functia fopen pentru a deschide fisierul
        ;functia eax va returna in  eax descriptorul fisierului sau 0 in caz de eroare
        ;eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2
        
        mov [descriptor_fisier], eax ;salvam valorea returnata de fopen in eax in variabila descriptor_fisier
        
        ;verificam daca functia fopen a deschis cu succes fisierul
        cmp eax, 0
        je final
        
        ;citim textul in fisierul deschis cu functia fread
        ;eax = fread(text, 1, len, descriptor_fisier) -> eax contine numarul de elemente citie
        push dword [descriptor_fisier]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        ;apelam functia fclose pentru a inchide fisierul
        ;fclose=(descriptor_fisier)
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 4
        
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
