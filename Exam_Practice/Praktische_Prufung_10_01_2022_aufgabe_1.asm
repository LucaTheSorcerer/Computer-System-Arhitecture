bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fread, fprintf, fopen, fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll 
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "prufung.txt", 0
    acces_mode db "r", 0
    file_descriptor dd -1
    number_characters dd 0
    len equ 100
    buffer times (len+1) db 0
    result_format db "%d", 0
    number_format db "%u", 0
    string_format db "%s with lenght %d", 10, 0
    s times 251 db 0
    w times 251 db 0
    l dd 3
    debugging db "It works", 0

; our code starts here
segment code use32 class=code
    start:
        mov eax, 0
        mov ebx, 0
        mov ecx, 0
        mov edx, 0
        mov esi, 0
        
        ;folosim functia fopen pentru a deschide fisierul
        ;fopen(file_name, acces_mode) --> eax = file_descriptor
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor], eax
        
        cmp eax, 0
        je final
        
        while_read_from_file:
            ;folosim functia fread penrtu a citi din fisier
            ;fread(buffer, 1, len, file_descriptor)
            ;buffer = continutul din fisier
            ;eax = numarul de caractere citite
            push dword [file_descriptor]
            push dword len
            push dword 1
            push dword buffer
            call [fread]
            add esp, 4 * 4
            
            cmp eax, 0 ;daca nu mai sunt caractere de citit 
            je final_while_read_from_file
            
            mov [number_characters], eax
            
            ;folosim functia printf pentru a afisa pe ecran textul citit
            ;fopen(buffer, string_format)
      
            mov edi, 0
            
            while_update_s:
            
            cmp edi, [number_characters]
            je end_while_update_s
            
            mov al, [buffer + edi]
            mov [s + esi], al
            
            inc esi
            inc edi
            
            jmp while_update_s
            
            end_while_update_s:
            
        jmp while_read_from_file
        
        
    final_while_read_from_file:
        push dword 0
        push dword s
        push dword string_format
        call [printf]
        add esp, 4 * 2
        
        mov esi, 0
        mov edi, 0
        
        while_go_through_s:
            ;push dword debugging
            ;push dword string_format
            ;call [printf]
            ;add esp, 4*2
        
            mov al, [s + esi]
            cmp al, 0
            
            je final
            
            cmp al, ' '
            je newWord
            cmp al, '.'
            je newWord
            
            notNewWord:
                mov [w + edi], al
                inc edi
                
                inc esi
                jmp while_go_through_s
                
            newWord:
                cmp edi, 3
                jne notPrint
                
                push dword edi
                push dword w
                push dword string_format
                call [printf]
                add esp, 4 * 2
                
                mov edi, 0
                
                notPrint:
                
                mov ecx, 251
                
                clear_w:
                    mov [w + ecx], byte 0
                    
                loop clear_w
                
                mov edi, 0
                
                inc esi
                jmp while_go_through_s
                
        
    final:
        cmp edi, 3
        jne notPrint_final
                
        push dword w
        push dword string_format
        call [printf]
        add esp, 4 * 2
        
        mov edi, 0
                
        notPrint_final:
    
        ;folosim functia fclose pentru a inchide fisierul
        ;fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
