.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD
WriteConsoleA PROTO, hConsoleOutput:DWORD, lpBuffer:PTR BYTE, nNumberOfCharsToWrite:DWORD, lpNumberOfCharsWritten:PTR DWORD, lpReserved:DWORD
GetStdHandle PROTO, nStdHandle:DWORD
STD_OUTPUT_HANDLE EQU -11

.data

welcome db 0dh,0ah ,"Welcome to this simple calculator written in assembly :D",0dh , 0ah ,0
welcome_length equ $ - welcome
written DWORD ?

.code
main PROC

INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov ebx, eax

INVOKE WriteConsoleA, ebx, ADDR welcome, welcome_length, ADDR written, 0

  INVOKE ExitProcess, eax
main ENDP

END main        