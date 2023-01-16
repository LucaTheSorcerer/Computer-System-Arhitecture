bits 32
global start        
extern exit, fopen, fread, fprintf, fclose, printf
import exit msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
import printf msvcrt.dll
import fclose msvcrt.dll

segment data use32 class=data

    input_file db "pruefung.txt", 0
    output_file db "output.txt", 0
    read_mode db "r", 0
    write_mode db "w", 0
    file_descriptor dd -1
    
    text times 201 db 0
    max_len equ 200
    len dd 0
    sformat db "%s ", 0
    
    has_upper db 0
    word_len equ 5
    
    exists db 0
    
    wrd times 20 db 0
    
    keine db "Keine Wörter", 0

segment code use32 class=code
    start:
    
        ;eax (file_descriptor) = fopen(input_file, read_mode)
        push dword read_mode
        push dword input_file
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        ;check if file was opened successfully
        cmp eax, 0
        je end
        
        ;eax (nr of chars read) = fread(text, 1, len, file_descriptor)
        push dword [file_descriptor]
        push dword max_len
        push dword 1
        push dword text
        call [fread]
        add esp, 4*4
        
        mov [len], eax      ;len = size of string
    
        ;fclose(file_descriptor)    -> close the input file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        
        ;open the output file:
        ;eax (file_descriptor) = fopen(output_file, write_mode)
        push dword write_mode
        push dword output_file
        call [fopen]
        add esp, 4*2
        
        mov [file_descriptor], eax
        
        ;check if file was opened successfully
        cmp eax, 0
        je end
        
        
        ;Write the whole text to output_file...
        push dword text
        push dword sformat
        push dword [file_descriptor]
        call [fprintf]
        add esp, 4*3
        
        
        mov esi, 0
        mov edi, 0
        while:
            mov al, [text+esi]
            cmp al, 0
            je endwhile
            
            cmp al, ' '
            je new_word
            cmp al, '.'
            je new_word
            
            cmp al, 'Z'
            ja not_new_word
            
            mov [has_upper], byte 1
            
            not_new_word:
                mov [wrd+edi], al
                inc edi
                inc esi
                jmp while
            
            new_word:
                
                cmp edi, word_len
                jl no_print
                
                mov dl, [has_upper]
                cmp dl, 1
                jne no_print
                
                push dword wrd
                push dword sformat
                call [printf]
                add esp, 4*2
                
                mov [exists], byte 1
                
                no_print:
                mov edi, 0
                inc esi
                mov [has_upper], byte 0
                
                while_clear_word:
                    mov al, [wrd+edi]
                    cmp edi, 20
                    je end_while_clear_word
                
                    mov al, 0
                    mov [wrd+edi], al
                    inc edi
                jmp while_clear_word
                end_while_clear_word:
                mov edi, 0
                
        jmp while
        endwhile:
        
        cmp [exists], byte 0
        jne end
        
        push dword keine
        push dword sformat
        call [printf]
        add esp, 4*2
        
    end:
        ;fclose(file_descriptor) -> close the output file
        push dword [file_descriptor]
        call [fclose]
        add esp, 4
        
        push    dword 0
        call    [exit]
