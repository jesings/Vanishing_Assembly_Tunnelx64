.global _start
.global data
.data
    x: .quad 0
    col: .quad 0x1234567890abcde
.bss
    data: .zero 786432#512*512*3
.text
_start:

    startl:
    cmpq $512, x
    jg endl
    pushq col
    mov $512, %rcx
    sub x, %rcx
    pushq %rcx
    pushq x//x1
    pushq $0//y0
    pushq $511//y1
    lea data, %rdx
    push %rdx
    call bresenham
    add $48, %rsp
    incq (x)
    rorq (col)
    jmp startl
    endl:

    movq $0, x
    startm:
    cmpq $512, x
    jg endm
    pushq col
    pushq $0//y0
    pushq $511//y1
    mov $512, %rcx
    sub x, %rcx
    pushq %rcx
    pushq x//x1
    lea data, %rdx
    push %rdx
    call bresenham
    add $48, %rsp
    incq (x)
    rorq (col)
    jmp startm
    endm:

    call pr
    mov $60, %rax               # system call 60 is exit
    xor %rdi, %rdi              # we want return code 0
    syscall
