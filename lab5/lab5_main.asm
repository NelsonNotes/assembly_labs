
    section .data
InMsg db "Called assembly procedure", 10 
    lenInM equ $-InMsg 
global _Z7correctPcS_
extern _Z5PrintPc
extern _Z4SwapPcS_
    section .text
_Z7correctPcS_:
    push RDI
    push RSI
    push RDX

    mov rax, 1 
    mov rdi, 1 
    mov rsi, InMsg 
    mov rdx, lenInM 
    syscall; message: "Called assembly procedure"

    pop RDX
    pop RSI
    pop RDI  
    call _Z4SwapPcS_
    ret