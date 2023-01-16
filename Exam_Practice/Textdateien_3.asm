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
    file_name db "Textdateien_3.txt", 0
    access_mode db "r", 0
    file_descriptor dd -1
    number_characters dd 0
    len equ 100
    buffer times (len + 1) db 0
    format db "%s", 0
    format2 db "There are %d even numbers", 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        
        ;citim continutul fisierului cu functia fread, pe care o apelam
        ;eax = fread(file_name, access_mode) -> in eax = file_descriptor 
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        ;verificam daca functia fread a deschis cu succes fisierul, adica eax != 0
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax ;salvam in file_descriptor valoarea din eax
        
        loop_read_from_file:
            ;citim pe rand cate 100 de caractere din fisier, 100 fiind numarul maxim
            ;folosim functia fread pentru a citi continutul din fisierul text
        
            ;eax = fread(buffer, 1, len, file_descriptor)
            ;eax = numarul de caractere citite
            ;buffer = continutul citit
            push dword [file_descriptor]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4 * 4
            
            cmp eax, 0 ;daca eax = 0, inseamna ca nu mai sunt caractere de citit si astfel am parcurs intreg fisierul
            je final
            
            mov [number_characters], eax
            
            mov eax, 0
            mov edx, 0
            mov esi, 0 ;folosim esi pentru a trece prin buffer si a verifica fiecare cifra
            
            while_check_characters:
                mov edx, 0
                mov dl, [buffer + esi]
                
                ;verificam daca elementul din buffer + esi stocat in dl, este o cifra
                
                cmp dl, '0'
                jb not_digit
                
                cmp dl, '9'
                jg not_digit
                
                ;daca este cifra, atunci trebuie sa verificam daca este par
                mov al, dl
                ;sub al, '0'
                
                ;verificam daca cifra din al este para sau nu
                
                test al, 1
                jnz not_even ;daca rezultatul este 0, atunci cifra este para
                
                inc ebx ;incrementam ebx pentru a pastra un counter
                
                not_even:
                not_digit:
                
                inc esi
                cmp esi, [number_characters]
                je loop_read_from_file
            jmp while_check_characters
            
        jmp loop_read_from_file
            
    final:
    
        ;folosim functia printf pentru a afisa pe ecran numarul de cifre pare
        ;printf(format, ebx)
        push dword ebx
        push dword format2
        call [printf]
        add esp, 4 * 2
        
        ;folosim functia fclose pentru a inchide fisierul
        ;fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
