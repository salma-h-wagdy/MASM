extrn ExitProcess: PROC
extrn WriteConsoleA: PROC
extrn GetStdHandle: PROC


.data
welcome db 0dh, 0ah, "Welcome to this simple calculator written in assembly :D", 0dh, 0ah, 0
welcome_length equ $ - welcome
written dq ?

.code
main PROC
    sub rsp, 28h
    mov ecx, -11
    call GetStdHandle
    mov rbx, rax

    lea rcx, [rbx]
    lea rdx, [welcome]
    mov r8d, welcome_length
    lea r9, [written]
    mov qword ptr [rsp+20h], 0
    call WriteConsoleA

    xor ecx, ecx
    call ExitProcess
main ENDP

END
