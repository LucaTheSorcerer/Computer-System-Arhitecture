;Codul de mai jos deschide un fisier numit "ana.txt" din directorul curent, va citi un text scurt din acel fisier, apoi va afisa in consola numarul de caractere citite si textul citit din fisier 
;Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru citirea din fisier si functia fclose pentru inchiderea fisierului creat

; In acest program sirul de caractere in care se va citi din fisier trebuie sa aiba o lungime cu 1 mai mare decat numarul maxim de elemente care vor fi citite din fisier deoarece acest sir va fi afisat in consola folosind functia printf
;Orice sir de caractere folosit de functia printf trebuie sa fie terminat cu 0, altfel afisarea nu va fi corecta
;Daca fisierul ar contine mai multe de <len> caractere si dimensiunea sirului destinatie era exact <len>, intregul sir ar fi fost completat cu valori citite din fisier, astfel sirul nu se mai termina cu valorea 0
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    nume_fisier db "ana.txt", 0 ;numele fisierului
    mod_acces db "r", 0 ;modul de deschidere a fisierului
                        ;r- pentru scriere; fisierul trebuie sa existe
    len equ 100 ;numarul maxim de elemente citite din fisier
    text times (len+1) db 0 ;sirul in care se va citi textul din fisier
    descriptor_fisier dd -1 ;variabila in care vom salva descriptorul fisierului -necesar pentru a face referire la fisier
    format db "Am citit %d caractere din fisier. Textul este: %s", 0 ;formatul utilizat pentru afisarea textului citit din fisier, %s reprezinta un sir de caractere
    
                                                    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;apelam functia fopen pentru a deschide fisierul
        ;functia va returna in eax descriptorul fisierului 
        ;eax = fopen(nume_fisier, mod_acces)
        push dword mod_acces
        push dword nume_fisier
        call [fopen]
        add esp, 4 * 2
        
        mov [descriptor_fisier], eax ;salvam valoarea returnatat de fopen in variabila descriptor_fisier
        
        ;verificam daca functia fopen a deschis fisierul cu success, adica eax != 0
        cmp eax, 0
        je final
        
        ;apel functia fread pentru a citi din fisier textul
        ;eax = fread(text, 1, len, descriptor_fisier) -> eax avem numarul de caractere citite si in text avem continutul citit 
        push dword [descriptor_fisier]
        push dword len
        push dword 1
        push dword text
        call [fread]
        add esp, 4 * 4
        
        ;afisam pe ecran numarul de caractere citite si continutul cu functia printf
        ;printf(format, eax, text)
        push dword text
        push dword eax
        push dword format
        call [printf]
        add esp, 4 * 3
        
        ;apelam functia fclose pentru a inchide fisierul
        ;fclose(descriptor_fisier)
        push dword descriptor_fisier
        call [fclose]
        add esp, 4
        
    final:
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
