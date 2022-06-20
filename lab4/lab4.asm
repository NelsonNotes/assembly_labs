section .data 
 InMsg db "Input array (28 elements)", 10 
 lenInM equ $-InMsg 
 OutMsg db "Final array:", 10 
 lenOutM equ $-OutMsg 
 ExitMsg db "Press Enter to exit!" 
 lenExit equ $-ExitMsg 
 EnterMsg db 0xa 
section .bss 
 InBuf resb 10 
 lenInB equ $-InBuf 
 OutBuf resb 10 
 lenOutB equ $-OutBuf 
 M resd 28
 N resd 28
section .text 
 %include "./lib.asm" 
 global _start  
_start: 
 mov rax, 1 
 mov rdi, 1 
 mov rsi, InMsg 
 mov rdx, lenInM 
 syscall 
  
 mov rcx, 28
 mov rbx, 0 
  
cycleIn: 
 push rcx 
 push rbx 
  
 mov rax, 0 
 mov rdi, 0 
 mov rsi, InBuf 
 mov rdx, lenInB 
 syscall 
  
 call StrToInt64 
 cmp rbx, 0 
 jne StrToInt64.Error 

 pop rbx
 mov[M+rbx*4], eax 
 inc rbx 
 pop rcx 
loop cycleIn 


 mov rcx, 3
 xor rdx, rdx ; for N array
cycleTypes: 
 cmp rcx, 2
 push rcx
 jg negative
 je positive
 jl zeros
negative:
 mov rcx, 28
 xor eax, eax
 xor rbx, rbx
cycle1: 
 mov eax, [M+rbx*4]
 inc rbx
 cmp eax, 0
 jnl skip1
 mov [N+rdx*4], eax
 inc rdx
skip1: 
loop cycle1
 jmp continueCycleTypes 
positive: 
 mov rcx, 28
 xor eax, eax
 xor rbx, rbx
cycle2: 
 mov eax, [M+rbx*4]
 inc rbx
 cmp eax, 0
 jng skip2
 mov [N+rdx*4], eax
 inc rdx
skip2: 
loop cycle2
 jmp continueCycleTypes 
zeros: 
 mov rcx, 28
 xor eax, eax
 xor rbx, rbx
cycle3: 
 mov eax, [M+rbx*4]
 inc rbx
 cmp eax, 0
 jne skip3
 mov [N+rdx*4], eax
 inc rdx
skip3: 
loop cycle3
 jmp continueCycleTypes 
continueCycleTypes: 
 pop rcx
 dec rcx
jnz cycleTypes
 
 mov rcx, 28
 xor rbx, rbx 
cycleOut1: 
 mov eax, [N+rbx*4] 
 inc rbx 
 push rbx 
 push rcx 

 mov rsi, OutBuf 
 call IntToStr64 
 mov rdi, 1 
 mov rdx, rax 
 mov rax, 1 
 syscall 
 pop rcx 
 pop rbx 
loop cycleOut1 
 
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