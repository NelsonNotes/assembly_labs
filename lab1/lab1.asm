	section .data
ExitMsg db "Press Enter to Exit",10
lenExit equ $-ExitMsg
A dw -30
B dw 21
	section .bss
InBuf resb 10 ; буфер для вводимой строки
lenIn equ $-InBuf
X resd 1
	section .text
	global _start
_start:
mov eax, [A]
add eax, 5
sub eax, [B]
mov [X], eax

; bb method
; write
mov rax, 1 ; системная функция 1 (write)
mov rdi, 1 ; дескриптор файла stdout=1
mov rsi, ExitMsg ; адрес выводимой строки
mov rdx, lenExit ; длина строки
; вызов системной функции
syscall
; read
mov rax, 0 ; системная функция 0 (read)
mov rdi, 0 ; дескриптор файла stdin=0
mov rsi, InBuf ; адрес вводимой строки
mov rdx, lenIn ; длина строки
; вызов системной функции
syscall
; exit
mov rax, 60 ; системная функция 60 (exit)
xor rdi, rdi ; return code 0
syscall
; вызов системной функции
