.global convert #convert takes in a byte value in rax and returns its string representation in rsi
.data
strResult:
    .zero 4# string buffer to store results
.text
convert:
 
    mov $10,%rcx         # divisor
    xor %rbx, %rbx         # count digits
divide:
    xor %rdx, %rdx       # high part = 0
    div %rcx             # rax = rdx:rax/rcx, rdx = remainder
    push %dx             # a digit in range [0..9]
    inc %bx              # count digits
    cmp $0, %rax         # rax is 0?
    jnz divide           # no, continue
    mov %bx, %cx         # pop digits from stack in reverse order
    lea strResult, %esi  # ds:si points to string buffer
next_digit:
    pop %ax
    add $0x30, %al       # convert to ASCII
    mov %al,(%esi)       # write it to the buffer
    inc %esi
    loop next_digit
    mov $0x20,%al
    mov %al,(%esi)       # write it to the buffer
    mov $strResult, %rax
    inc %bx
    mov %rbx,%rcx
    ret
