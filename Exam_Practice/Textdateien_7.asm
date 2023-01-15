;Lese eine Dateinamen und einen Text von der Tastatur.
;Erstelle eine Datei mit diesem Namen im akutellen Ordner und schreibe den
;gelesenen Text in  der Datei.
;Der Dateiname hat maximal 30 Zeichnen. Der Text hat maximal 120 Zeichnen
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fclose, fopen, fprintf, scanf, printf, gets               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll
import fprintf msvcrt.dll
import gets msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    string_format db "%s", 0
    message_file_name db "File = ", 0
    message_text db "Text = ", 0
    
    file_name times 30 db 0
    text times 120 db 0
    acces_mode db "w", 0
    file_descriptor dd -1

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;folosim functia printf pentru a afisa pe ecran message_file_name
        ;printf(message_file_name)
        push dword message_file_name
        call [printf]
        add esp, 4
        
        ;folosim functia scanf pentru a citi de la tastatura file_name
        ;scanf(string_format, file_name)
        push dword file_name
        push dword string_format
        call [scanf]
        add esp, 4 * 2
        
        ;folosim functia printf pentru a afisa pe ecran message_text
        ;printf(message_text)
        push dword message_text
        call [printf]
        add esp, 4
        
        ;folosim functia scanf pentru a citi de la tastatura textul
        ;scanf(string_format, text)
        push dword text
        push dword string_format
        call [scanf]
        add esp, 4 * 2
        
        ;folosim functia fopen pentru a deschide fisierul file_name cu modul w si a-l crea
        ;fopen(file_name, acces_mode)
        push dword acces_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        cmp eax, 0
        je final
        
        mov [file_descriptor], eax
       
        
        ;folosim functia fprintf pentru a scrie in fisier textul
        ;fprintf(file_descriptor, text)
        push dword text
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4 * 2
        
        
        
    final:
        ;folosim functia fclose pentru a inchide fisierul
        ;fclose(file_descriptor)
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
