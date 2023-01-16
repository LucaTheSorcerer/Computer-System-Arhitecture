bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fopen, fclose, fprintf, printf, scanf,fread      
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll    
import fopen msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import scanf msvcrt
import fread msvcrt
; The following code will open/create a file called "ana.txt" in the current folder, and it will write a text at the end of this file.
; The program will use:
; - the function fopen() to open/create the file
; - the function fprintf() to write a text to file
; - the function fclose() to close the created file.
; Because the fopen() call uses the file access mode "a", the writing operations will append text at the end of the file. The file will be created if it does not exist.

; our data is declared here (the variables needed by our program)
segment data use32 class=data  
    file_name db "input.txt", 0
    file_name_output db "output.txt", 0
    acces_mode db "r", 0 ;reading mode
    acces_mode_write db "w", 0 ;write mode
    file_descriptor dd -1
    file_descriptor_output dd -1
     
    format_old db "Old text: %s",0Ah,0
    format db "New text: %s",0Ah,0
     
    len equ 1
    caracter resb len
    word1 times 401 db 0
    text times 200 db 0

; our code starts here
segment code use32 class=code
    start:
         
         push dword acces_mode
         push dword file_name
         call [fopen] 
         add esp, 4*2
         
         cmp eax, 0
         je final
         
         mov [file_descriptor], eax ;
         mov edx,0
         mov edi,0
         mov esi,0
         
         citire:
            push dword [file_descriptor]
            push dword len
            push dword 1
            push dword caracter
                 call [fread] ;reads every character
                 add esp, 4*4
                 
                 cmp eax, 0
                 je inchidere_fisier
                 
                 mov eax,0
                 mov al,[caracter]
                 
                 mov [text+esi],al
                 inc esi
                 
                 cmp al,'0' 
                 jl not_number 
                 cmp al,'9'
                 jg not_number
                 mov [word1+edi],al
                 inc edi
                 jmp citire
                 not_number:
            
                ; checking if our character is a lowercase letter or not (verify if character is between 'a' and 'z')
            
                    ; in case it isn't, go to label not_lowercase_letter
                    ; in case it is, go to the while label => move on to the next character 
            
                                cmp al,'a'
                                jl not_lowercase_letter
                                cmp al,'z'
                                jg not_lowercase_letter
                                mov [word1+edi],al
                                inc edi
                                jmp citire
                
                 not_lowercase_letter:
            
                                ; checking if our character is an uppercase letter or not (verify if character is between 'A' and 'Z')
                            
                                    ; in case it isn't, go to label not_uppercase_letter
                                    ; in case it is, go to the while label => move on to the next character 
                            
                                cmp al,'A'
                                jl not_uppercase_letter
                                cmp al,'Z'
                                jg not_uppercase_letter
                                mov [word1+edi],al
                                inc edi
                                jmp citire
                
                 not_uppercase_letter:
                    
                                ; we know now that our character is not a number, not an uppercase or lowercase letter and that means that our char is a special char
                                mov [word1+edi],al
                                inc edi
                                mov [word1+edi],al
                                inc edi
                                jmp citire
            
        inchidere_fisier:
              push dword [file_descriptor]
              call [fclose]
              add esp, 4*1
              
        push dword acces_mode_write
        push dword file_name_output
        call [fopen] 
        add esp, 4*2
         
        mov [file_descriptor_output], eax
        
        ;print old text on the screen
        push text
        push dword format_old
        call [printf]
        add esp,4*2

        ; print new text on the screen
        push word1
        push dword format
        call [printf]
        add esp,4*2
        
        push word1
        push dword format
        push dword [file_descriptor_output]
        call [fprintf]
        add esp, 4*3
        
        ;close output file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4*1
            
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
