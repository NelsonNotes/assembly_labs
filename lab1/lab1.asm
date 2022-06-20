section .data
  twentyFive dw 25
  negativeThirtyFive dd -35
  name db "Никита Nikita"
  b25 dw 0x0025
  l25 dw 0x2500
  F1 dw 65535
  F2 dd 65535
section .bss
section .text
global _start
_start:
  add [F1], word 1
  add [F2], dword 1
  mov rax, 60
  mov rdi, 0
  syscall
