    section .data
InMsg db "Input string", 10
lenIn equ $-InMsg
ExitMsg db "Press Enter to exit!" 
lenExit equ $-ExitMsg 
OutMsgWords db "Words count: "
lenOutWords equ $-OutMsgWords
OutMsgLetters db "Letters: "
lenOutLetters equ $-OutMsgLetters
    section .bss
InBuf resb 30
lenInB equ $-InBuf
OutBuf resb 30
lenOutB equ $-OutBuf
string resb 32
letters resw 32
letters_len resb 2
    section .text
%include "lib.asm"
global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, InMsg
    mov rdx, lenIn
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, string
    mov rdx, 32
    syscall

    mov rcx, 0
    mov rdx, 0
    push rcx
    push rdx
    mov rdi, string
loop:
    movsx rbx, byte[rdi]
    cmp rbx, ' '
    je space
    cmp rbx, 0xa
    je end
    pop rdx 
    inc rdx 
    push rdx
    inc rdi
    jmp loop
space:
    pop rdx
    pop rcx
    mov [letters + rcx*2], rdx
    mov [letters_len], rcx
    inc rcx
    mov rdx, 0
    inc rdi
    push rcx
    push rdx
    jmp loop
end:
    pop rdx
    pop rcx
    mov [letters + rcx*2], rdx
    cmp rdx, 0
    je skip_rcx_inc
    inc rcx
skip_rcx_inc:
    push rcx

    mov rax, 1 
    mov rdi, 1 
    mov rsi, OutMsgWords
    mov rdx, lenOutWords 
    syscall 
    pop rcx
    mov rax, rcx
    mov [letters_len], rcx
    mov rsi, OutBuf 
    call IntToStr64 
    mov rdi, 1 
    mov rdx, rax 
    mov rax, 1 
    syscall 

    mov rcx, [letters_len]
    mov rbx, 0
    cmp rcx, 0
    je skip_loop_out
loopOut:
    push rcx
    push rbx

    mov rax, 1 
    mov rdi, 1 
    mov rsi, OutMsgLetters
    mov rdx, lenOutLetters
    syscall 

    pop rbx
    mov rax, [letters + rbx*2]
    push rbx
    mov rsi, OutBuf 
    call IntToStr64 
    mov rdi, 1 
    mov rdx, rax 
    mov rax, 1 
    syscall

    pop rbx
    inc rbx
    pop rcx
    loop loopOut
skip_loop_out:
    mov rax, 1 
    mov rdi, 1 
    mov rsi, ExitMsg 
    mov rdx, lenExit 
    syscall 
    mov rax, 0 
    mov rdi, 0 
    mov rsi, InBuf 
    mov rdx, lenInB 
    syscall 

    mov rax, 60 
    xor rdi, rdi 
    syscall