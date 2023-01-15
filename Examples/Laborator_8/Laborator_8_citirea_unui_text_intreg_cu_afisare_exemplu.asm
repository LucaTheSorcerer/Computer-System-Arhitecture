;Codul de mai jos va deschide fisierul numit "input.txt" din directorul curent si va citi intregul text din acel fisier, in etapte, cate 100 de caractere intr-o etapa
;Deoarece un fisier text poate fi foarte lung, nu este intotdeauna posibil sa citim fisierul intr-o singura etapa pentru ca nu putem defini un sir de caractere suficient de lung pentru intregul text din fisier. De aceea, prelucrarea fisierelor text in etape este necesara
; Programul va folosi functia fopen pentru deschiderea fisierului, functia fread pentru a citi caracterele, printf pentru afisarea pe ecran, fclose pentru a inchide fisierul

bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, printf, fread               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import fread msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    nume_fisier db "input.txt", 0 ;numele fisierului care va fi deschis
    mod_acces db "r", 0 ;modul de deschidere a fisierului
                        ;r - pentru citire
    descriptor_fisier dd -1 ;variabila in care se salveaza descriptorul fisierului - necesar pentru a putea face referire la fisier 
    nr_caractere_citite dd 0 ;variabila in care vom salva numarul de caractere citit din fisier in etapa curenta
    len equ 100 ;numarul maxim de elemente citite din fisier intr-o etapa
    buffer resb len ;sirul in care se va citi textul din fisier
    format db "%s", 0
    

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
        
        ;verificam daca functia fopen a deschis cu succes fisierul, adica eax != 0
        cmp eax, 0
        je final
        
        mov [descriptor_fisier], eax ;salvam valoarea returnata in eax in variabila descriptor_fisier
        
        bucla:
            ;citim o parte (100 caractere) din textul in fisierul deschis, folosind functia fread
            ;eax = fread(buffer, 1, len, descriptor_fisier); buffer = ce am citit
            push dword [descriptor_fisier]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4 * 4
            
            ;eax = numarul de caractere citite
            cmp eax, 0 ;daca numarul de caractere citite este 0, am terminat de parcurs fisierul
            je cleanup
            
            mov [nr_caractere_citite], eax ;salvam numarul de caractere citite
            
            ;afisam pe ecran textul citit cu functia printf
            ;printf(buffer, format)
            push dword format
            push dword buffer
            call [printf]
            add esp, 4 * 2
            
            ;reluam bucla pentru a citi alt bloc de caractere
            jmp bucla
        
    cleanup:
    ;apelam functia fclose pentru a inchide fisierul
    ;fclose(descriptor_fisier)
    push dword descriptor_fisier
    call [fclose]
    add esp, 4
    final:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
