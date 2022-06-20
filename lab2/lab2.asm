	section .data ; сегмент инициализированных переменных
mMsg db "Input M value: "
len_m equ $-mMsg
aMsg db "Input A value: "
len_a equ $-aMsg
bMsg db "b= "
len_b equ $-bMsg
D db 2
	section .bss ;сегмент неинициализированных переменных
InBuf resb 10
lenIn equ $-InBuf
OutBuf resb 20
lenOut equ $-OutBuf
M resw 1
A resw 1
B resw 1
	section .text ; сегмент кода b = (m - 5) * (m + 2) + m + a/2
%include "./lib.asm"

global _start
_start:

mov RAX, 1
mov RDI, 1
mov RSI, mMsg
mov RDX, len_m
syscall

mov RAX, 0
mov RDI, 0
mov RSI, InBuf
mov RDX, lenIn
syscall

call StrToInt64
cmp RBX, 0
jne StrToInt64.Error
mov [M], RAX


mov RAX, 1
mov RDI
mov RSI, aMsg
mov RDX, len_a
syscall

mov RAX, 0
mov RDI, 0
mov RSI, InBuf
mov RDX, lenIn
syscall

call StrToInt64
cmp RBX, 0
jne StrToInt64.Error
mov [A], RAX

mov AX, [M]
sub AX, 5
mov BX, [M]
add BX, 2
imul BX
mov [B], AX
mov AX, [A]
idiv byte [D]
add AX, [M]
add [B], AX

mov RAX, 1
mov RDI, 1
mov RSI, bMsg
mov RDX, len_b
syscall
mov esi, OutBuf
mov ax, [B]
cwde
call IntToStr64 ;lenght in eax, start at [esi]
mov RDI, 1
mov RDX, RAX
mov RAX, 1
syscall

mov RAX, 60
xor RDI, RDI
syscall
