extrn ExitProcess: PROC
extrn WriteConsoleA: PROC
extrn ReadConsoleA :Proc
extrn GetStdHandle: PROC

STD_INPUT_HANDLE equ -10
STD_OUTPUT_HANDLE equ -11

.data
welcome db 0dh, 0ah, "Welcome to this simple calculator written in x64 bit assembly :D", 0dh, 0ah, 0
welcome_length equ $ - welcome
written dq ?
options db "1-Add", 0dh, 0ah, "2-Subtract", 0dh, 0ah, "3-Multiply", 0dh, 0ah, "4-Divide", 0dh, 0ah, 0
msgFirst db 0dh, 0ah, "Enter First Number: ", 0
msgSecond db 0dh, 0ah, "Enter Second Number: ", 0
msgResult db 0dh, 0ah, "Result: ", 0
msgError db 0dh, 0ah, "Error!", 0dh, 0ah, 0
inputBuffer db 100 dup(0)
inputLength dq ?
intBuffer db 16 dup(0)


.code
main PROC
    sub rsp, 28h
    mov ecx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rbx, rax

    lea rcx, [rbx]
    lea rdx, [welcome]
    mov r8d, welcome_length
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    lea rcx, [rbx]
    lea rdx, [options]
    mov r8d, sizeof options - 1
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

     mov ecx, STD_INPUT_HANDLE
    call GetStdHandle
    mov rsi, rax
    
    call choiceLoop
    
    xor ecx, ecx
    call ExitProcess

main ENDP

choiceLoop proc
    ; Read user choice
    lea rcx, [rsi]
    lea rdx, [inputBuffer]
    mov r8d, sizeof inputBuffer
    lea r9, [inputLength]
    mov qword ptr [rsp+20h], 0
    call ReadConsoleA

    movzx eax, byte ptr [inputBuffer]
    sub eax, '0'
    cmp eax, 1
    je Addition
    jmp Error

choiceLoop endp

Addition PROC
    call GetNumbers
    add rax, rdx
    jmp PrintResult
Addition ENDP


Error Proc
    lea rcx, [rbx]
    lea rdx, [msgError]
    mov r8d, sizeof msgError - 1
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA
    jmp choiceLoop
Error Endp

GetNumbers PROC
    ; Get first number
    lea rcx, [rbx]
    lea rdx, [msgFirst]
    mov r8d, sizeof msgFirst - 1
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    lea rcx, [rsi]
    lea rdx, [inputBuffer]
    mov r8d, sizeof inputBuffer
    lea r9, [inputLength]
    mov qword ptr [rsp+20h], 0
    call ReadConsoleA
    ;mov byte ptr [inputBuffer + rax], 0 
    
    lea rdi, [inputBuffer] ; Load effective address of inputBuffer into rdi
    mov rcx, rax          ; Move the number of characters read into rcx
    inc rcx               ; Increment rcx to account for the null terminator position
    mov byte ptr [rdi + rcx - 1], 0 ;
    
    
    call StringToInt
    mov rax, rbx

    lea rcx, [inputBuffer]
    mov rdx, sizeof inputBuffer
    call ZeroMemory

    ; Get second number
    lea rcx, [rbx]
    lea rdx, [msgSecond]
    mov r8d, sizeof msgSecond - 1
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    lea rcx, [rsi]
    lea rdx, [inputBuffer]
    mov r8d, sizeof inputBuffer
    lea r9, [inputLength]
    mov qword ptr [rsp+20h], 0
    call ReadConsoleA
    call StringToInt
    mov rdx, rbx

    ret
GetNumbers ENDP

ZeroMemory PROC
    push rdi
    mov rdi, rcx       ; rcx should contain the address of the buffer
    mov rcx, rdx       ; rdx should contain the size of the buffer
    xor al, al
    rep stosb          ; Zero out memory
    pop rdi
    ret
ZeroMemory ENDP

StringToInt PROC
    xor rbx, rbx
    lea rcx, [inputBuffer]
    mov rdx, [inputLength] 

   ; mov rdx, inputBuffer + sizeof inputBuffer - 1

next_digit:

    cmp rcx, rdx          ; Check if end of the input
    jae done   
    
    movzx rax, byte ptr [rcx]
   ; test rax, rax
    ;je done



    ;cmp rcx, rdx ;
    ;ja done ;

    
    cmp rax, '0'
    jl invalid_character       ; Jump if less than '0'
    cmp rax, '9'
    jg invalid_character   

    sub rax, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rcx
    jmp next_digit

     ;mov rbx, rax 

invalid_character:
    mov rbx, -1                ; Set rbx to a special value to indicate error
    ;jmp done     
    ret

done:
    ret
StringToInt ENDP

PrintResult PROC
    
    lea rcx, [rbx]
    lea rdx, [msgResult]
    mov r8d, sizeof msgResult - 1
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    ; Convert and print result number
    call IntToString
    lea rcx, [rbx]
    lea rdx, [inputBuffer]
    mov r8, rax
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

  
    ; Wait for key press
    mov ecx, STD_INPUT_HANDLE
    call GetStdHandle
    mov rsi, rax
    lea rcx, [rsi]
    lea rdx, [inputBuffer]
    mov r8d, 1
    lea r9, [inputLength]
    mov qword ptr [rsp+20h], 0
    call ReadConsoleA

    jmp choiceLoop
PrintResult endp

IntToString PROC
    mov rbx, rax
    lea rcx, [intBuffer]
    add rcx, sizeof intBuffer - 1
    mov byte ptr [rcx], 0
reverse_digits:
    dec rcx
    xor rdx, rdx
    mov rax, rbx
    mov rdi, 10
    div rdi
    add dl, '0'
    mov byte ptr [rcx], dl
    test rax, rax
    jnz reverse_digits
    mov rax, rcx
    ret
IntToString ENDP




END