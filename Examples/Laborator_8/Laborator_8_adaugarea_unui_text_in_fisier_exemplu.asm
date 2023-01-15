;Codul de mai jos va deschide fisierul numit "ana.txt" in directorul curent si va adauga un text la finalul acelui fisier
;Programul va folosi functia fopen pentru deschiderea/crearea fisierului, functia fprintf pentru scrierea in fisier si functia fclose pentru inchiderea fisierului creat
;Deoarece in apelul functiei fopen programul foloseste modul de acces "a", daca un fisier cu numele exista deja in directorul curent, la continutul acelui fisier se va adauga un text. Daca fisierul cu numele dat nu exista, se va crea un fisier nou cu acel nume si se va scrie textul in fisier
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    nume_fisier db "ana.txt", 0 ;numele fisierului care va fi creat
    mod_acces db "a", 0         ;modul de deschidere a fisierului
                                ;a-pentru adaugare. Daca fisierul nu exista, se va crea fisierul
    text db "Ana are si pere", 0;textul care va fi adaugat in fisier
    descriptor_fisier dd -1 ;variabila in care vom salva descriptorul fisierului - necesar pentru a putea face referire la fisier

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;apelam fopen pentru a crea fisierul
        ;functia va returna in eax descriptorul fisierului sau 0 in caz de eroare
        ;eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2
        
        mov [descriptor_fisier], eax ;salvam valorea returnata de fopen in variabila descriptor_fisier
        
        ;verificam daca functia fopen a creat cu succes fisierul (daca EAX != 0)
        cmp eax, 0
        je final
        
        ;adaugam/scriem textul in fisier cu functia fprintf
        ;fprintf(descriptor_fisier, text)
        push dword text
        push dword [descriptor_fisier]
        call [fprintf]
        add esp, 4 * 2
        
        ;apelam functia fclose pentru a inchide fisierul
        ;fclose(descriptor_fisier)
        push dword [descriptor_fisier]
        call [fclose]
        add esp, 4
        
        final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
