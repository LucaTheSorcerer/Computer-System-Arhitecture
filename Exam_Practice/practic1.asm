bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, fopen, fclose, fread, printf, fprintf              ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
import fprintf msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    file db "pruefung.txt", 0
    file2 db "output.txt", 0
    len equ 100
    buffer times 100 db 0 
    s times 201 db 0
    mode db "r", 0 
    mode2 db "w", 0 
    descriptor dd -1
    descriptor2 dd -1
    nr_caractere dd 0
    format db "%s", 0
    mesaj db "Keine Sonderzeichen", 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword mode
        push dword file
        call [fopen]
        add esp, 4*2
	
        cmp eax, 0
        je ende
	
        mov [descriptor], eax
	
        push dword [descriptor]
        push dword len
        push dword 1
        push dword buffer
        call [fread]
        add esp, 4*4
	
        cmp eax, 0
        je ende
	
        mov [nr_caractere], eax
        
        mov esi, 0
        mov edi, 0
        build_string:
            cmp edi, [nr_caractere]
            je ende
            
            mov al, [buffer+edi]
            mov [s+esi], al
            
            cmp al, 32
            je alphaNumeric
            
            cmp al, '0'
            jl notAlphaNumeric
            cmp al, '9'
            jl alphaNumeric
			
            cmp al, 'A'
            jl notAlphaNumeric
            cmp al, 'Z'
            jl alphaNumeric
			
            cmp al, 'a'
            jl notAlphaNumeric
            cmp al, 'z'
            jl alphaNumeric
            
            notAlphaNumeric:
			inc esi
			mov [s + esi], al
            
            alphaNumeric:
            inc esi
            inc edi
            jmp build_string
        ende:
        
        ; cmp esi, [nr_caractere]
        ; jne Sonderzeichen
        
        ; push dword mesaj
        ; call [printf]
        ; add esp, 4
        
        ; mov ebx, ' '
        ; push dword ebx
        ; push dword format
        ; call [printf]
        ; add esp, 4
        
        ; Sonderzeichen:
        push dword [descriptor]
        call [fclose]
        add esp, 4 
        
        push dword s
        push dword format
        call [printf]
        add esp, 4*2
        
        
        push dword mode2
        push dword file2
        call [fopen]
        add esp, 4*2
        
        mov [descriptor2], eax 
        
        cmp eax, 0
        je ende1
        
        push dword s
        push dword format
        push dword [descriptor2]
        call [fprintf]
        add esp, 4*3
        
        push dword [descriptor2]
        call [fclose]
        add esp, 4
        ende1:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
