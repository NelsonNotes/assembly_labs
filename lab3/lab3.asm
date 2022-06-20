section .data ; сегмент инициализированных переменных
    aMsg db "Input A value: "
    len_a equ $-aMsg
    xMsg db "Input X value: "
    len_x equ $-xMsg
    yMsg db "Input Y value: "
    len_y equ $-yMsg
    fMsg db "f = "
    len_f equ $-fMsg
    zDivMsg db "Zero division! Check your x and y values!", 10
    len_zDivMsg equ $-zDivMsg
section .bss ;сегмент неинициализированных переменных
    InBuf resb 10
    lenIn equ $-InBuf
    OutBuf resb 20
    lenOut equ $-OutBuf
    A resw 1
    X resw 1
    Y resw 1
    F resw 1
section .text ; сегмент кода f = a * x^2 если x > 0, иначе f = a / y - x
    %include "./lib.asm"

global _start
_start:

    mov RAX, 1
    mov RDI, 1
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

    mov RAX, 1
    mov RDI, 1
    mov RSI, xMsg
    mov RDX, len_x
    syscall

    mov RAX, 0
    mov RDI, 0
    mov RSI, InBuf
    mov RDX, lenIn
    syscall

    call StrToInt64
    cmp RBX, 0
    jne StrToInt64.Error
    mov [X], RAX

    cmp EAX, 0
    jg skipY

    mov RAX, 1
    mov RDI, 1
    mov RSI, yMsg
    mov RDX, len_y
    syscall

    mov RAX, 0
    mov RDI, 0
    mov RSI, InBuf
    mov RDX, lenIn
    syscall

    call StrToInt64
    cmp RBX, 0
    jne StrToInt64.Error
    mov [Y], RAX

    mov AX, [A]
    mov BX, [Y]
    sub BX, [X]
    cmp BX, 0
    je error
    idiv BX
    mov [F], AX
    jmp result

skipY:
    mov AX, [X]
    imul AX
    mov BX, [A]
    imul BX
    mov [F], AX

result:
    mov RAX, 1
    mov RDI, 1
    mov RSI, fMsg
    mov RDX, len_f
    syscall
    mov esi, OutBuf
    mov ax, [F]
    cwde
    call IntToStr64 ;lenght in eax, start at [esi]

    mov RDI, 1
    mov RDX, RAX
    mov RAX, 1
    syscall
    jmp end
error:
    mov rax, 1 
    mov rdi, 1 
    mov rsi, zDivMsg 
    mov rdx, len_zDivMsg 
    syscall 
end:
    mov RAX, 60
    mov RDI, 0
    syscall
