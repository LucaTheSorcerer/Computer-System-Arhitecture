bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, fread, fopen, fclose              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fread msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fclose msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file_name db "fisier.txt", 0
    result_format db "Die Buchstabe %c erscheint %d mal", 0 
    read_mode db "r", 0 ;offnet eine Datei in read mode, die Datei soll existieren
    file_descriptor dd -1 ;eine handle fur unsere Datei
    len equ 100 ;man kan maximal 100 characters einmal lesen
    letters times (len+1) db 0 ;string wo man den gelesene text von file speichern kann
    counter times 26 db 0
    number_read_characters dd 0
    maximum_letter dd 0
    counter_maxim dd 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword read_mode ;wir legen read_mode "r" auf den stack, also was wir mit den Datei machen wollen
        push dword file_name ;wir legen die Name unserer Datei auf den Stack
        call [fopen] ;wir rufen die Funktion fopen an, so dass wir unsere Datei offnen konnen
        add esp, 4 * 2 ;wir loschen die obigen Paramteren von den Stack auf
        
        
        mov [file_descriptor], eax ;wir speichern in file_descriptor den wert die fopen uns zuruckgibt 
        cmp eax, 0 ;hier mochten wir uberprufen, ob unsere Datei richtig geoffnet wurde
        je end_program ;wenn es nicht richtig geoffnet wurde, dann gehen wir am ende unsere Programm
        
        push dword [file_descriptor]
        push dword len
        push dword 1
        push dword letters
        call [fread] ;eax enthalt wie viele characters gelesen wurden
        add esp, 4 * 4
        
        mov [number_read_characters], eax ;wir speichern eax in number_read_characters, also wie viele characters gelesen wurden
        mov bl, 97 ; 'a' = 97 in ascii
        mov edi, 0
        
        while_loop_1:
            cmp bl, 123 ; 'z' = 122 in ascii
            je end_while_loop_1 ;wenn bl = 123, dann springt unsere schleife am Ende, weil nach 122 keine Buchstaben mehr gibt
            mov esi, letters ;wir legen unsere gelesene Text in esi
            mov ecx, [number_read_characters] ;wir legen in ecx den Anzahl von was wir gelesen haben
            mov edx, 0
            jecxz end_for_loop ;wenn ecx = 0, dann springt zum end_for_loop
                for_loop:
                    lodsb ;ein byte von <DS:ESI> wird in register al eingeladen
                    cmp al, bl ;wir machen einen compare zwischen al und bl
                    je if ;wenn al und bl gleich sind, springt unsere schleife zu if
                    jmp end_if ;wenn al und bl nicht gleich sind, spring unsere schleife zu end_if
                    if:
                    inc dl ;wir benutzen dl als ein counter fur die Erscheinungen einer Buchstabe
                    end_if:
                    loop for_loop
                    mov byte[counter + edi], dl ;dl wird in counter auf der Position edi gespeichert
                end_for_loop:
            inc bl ;wir incrementieren bl bis bl 123 ist und dann stopt
            inc edi ;man incrementiere edi, also die position fur counter
        jmp while_loop_1    
        end_while_loop_1:
        
        
        mov esi, counter ;wir speichern counter in esi, also das array der erscheinungen
        mov ebx, 0
        mov ebx, 97 ;ebx = 97 = a in ascii
        while_loop_letter_2:
            cmp ebx, 123 ;z =122 in ascii
            jge end_while_loop_letter_2 ;wenn ebx >= 123, dann springt zum end_while_loop_letter_2
            lodsb ;ein byte von <DS:ESI> wird in al register eingeladen
            cmp al, byte[counter_maxim]
            jle end_if_maximum ;wenn <= ist, dann springt zum end_if_maximum
            mov byte [counter_maxim], al ;counter_maxim bekommt den wert von al
            mov dword [maximum_letter], ebx ;wir speichern den wert von ebx, wo unsere Buchstabe ist, in maximum_letter
            end_if_maximum:
            inc ebx; wir incrementieren ebx, also die nachste Buchstabe
        jmp while_loop_letter_2
        end_while_loop_letter_2:
        
        
        ;printf(format, maximum_letter, counter_maxim, eax)
        mov eax, 0
        mov al, byte[counter_maxim] ;in al speichern wir den counter_maxim, also den maximal Anzahl von Erscheinungen einer Buchstabe
        push dword eax ;wir legen eax auf den stack
        push dword [maximum_letter] ;in maximum_letter haben wir den Buchstabe mit der hochste Anzahl von Erscheinungen, wir legen es auf den stack
        push dword result_format ;in result_format haben wir den Weise, wie wir unsere Ergebnisse auf den Bildschirm zeigen mochten, wir legen es auf den stack
        call [printf] ;wir rufen die Funktion printf an
        add esp, 4 * 3 ;wir loschen unsere Paramter auf den Stack
        
        push dword [file_descriptor] ;wir legen file_descriptor auf den stack
        call [fclose] ;wir schliessen die Datei
        add esp, 4
        end_program:
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
