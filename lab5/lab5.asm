    section .data
InMsg db "Input string", 10
lenIn equ $-InMsg
OutMsgWords db "Kol-vo bukv 'a': "
lenOutWords db $-OutMsgWords
OutMsgLetters db "Kol-vo bukv 'a': "
lenOutLetters db $-OutMsgLetters
    section .bss
OutBuf resb 2
string1 resb 125
string2 resb 125
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
mov rsi, string1
mov rdx, 125
syscall

mov rcx, 0
push rcx
mov rdi, string
loop:
movsx rbx, byte[rdi]
cmp rbx, 'a'
je A
cmp rbx, 'A'
je A
cmp rbx, 0xa
je EndString
inc rdi
jmp loop
A:
pop rcx
inc rcx
push rcx
inc rdi
jmp loop
EndString:

mov rax, 1
mov rdi, 1
mov rsi, OutMsgWords
mov rdx, lenOutWords
syscall

push rbx
pop rcx
mov rax, rcx
mov esi, OutBuf
call IntToStr64
cmp rbx, 0
pop rbx
jne StrToInt64.Error
mov rdi, 1
;mov rsi, OutBuf
mov rdx, rax
mov rax, 1
syscall

mov rax, 60
xor rdi, rdi
syscall