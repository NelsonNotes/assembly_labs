
    section .data
InMsg db "Вызвана подпрограмма NASM", 10
    InMsgLen equ $-InMsg
global _Z7correctPcS_
extern _Z5PrintPc
    section .text
_Z7correctPcS_:
    push rdi
    push rsi
    mov rdi, InMsg
    call _Z5PrintPc
    pop rdi
    pop rsi

    mov rcx, 125
    mov rax, 0
cycle:
    push rcx
    mov dh, [rdi+rax]
    mov dl, [rsi+rax]

    push rax
    cmp dh, dl
    pop rax
    jne skip
    mov byte[rdi+rax], ' '
    mov byte[rsi+rax], ' '
skip:
    inc rax
    pop rcx
loop cycle
    ret