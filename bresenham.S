.global bresenham
.extern data
.data
x: .quad 0
y: .quad 0
x0: .quad 0
x1: .quad 0
y0: .quad 0
y1: .quad 0
colorR:
    .byte 255 
colorG:
    .byte 255 
colorB:
    .byte 255
    .align 8
.text
bresenham: //something like this: bresenham(int color,int x0,int x1, int y0, int y1), color is a hex value
#process arguments
    mov 48(%rsp), %rcx
    movb %cl, colorB
    shr $8, %rcx
    movb %cl, colorG
    shr $8, %rcx
    movb %cl, colorR

    mov 40(%rsp), %rcx
    mov %rcx, x0
    mov 32(%rsp), %rcx
    mov %rcx, x1
    mov 24(%rsp), %rcx
    mov %rcx, y0
    mov 16(%rsp), %rcx
    mov %rcx, y1
    mov 8(%rsp), %rcx
#handle wrong direction coords
    mov x0, %rcx
    cmp x1, %rcx
    jl noswap
    xchg x1, %rcx
    mov %rcx, x0
    mov y0, %rcx
    xchg y1, %rcx
    mov %rcx, y0
    noswap:
#assign x and y
    movq x0, %r8
    movq %r8, x //x = x-naught
    movq y0, %r8
    movq %r8, y //y = y-naught
#assign a b and d
    movq y0, %rax
    subq y1, %rax//A = y-naught - y-one these needed to be negated for some reason...?
    movq x1, %rbx
    subq x0, %rbx//B = x-one - x-naught
#differentiate between octants
    cmp $0, %rax
    jl topq
    bottomq:
    cmp %rax, %rbx
    jg o7
    jmp o8
    topq:
    mov %rax, %rcx
    neg %rcx
    cmp %rcx,%rbx
    jg o1
    jmp o2
#A is rax, B is rbx, rdx is d (twice d actually)
o1:
    movq %rax,%rdx //d=2a+b
    salq %rdx
    addq %rbx, %rdx
    salq %rax
    salq %rbx //double a and b
    start1:
    mov x1, %rcx
    cmpq x, %rcx
    jl end
    call plot
    cmp $0,%rdx#check if y needs to be incremented
    jg ifninc1
    incq (y)
    add %rbx, %rdx
    ifninc1:
    incq (x)
    add %rax, %rdx
    jmp start1
o2:
    neg %rax
    neg %rbx
    movq %rbx,%rdx //d=2b+a
    salq %rdx
    addq %rax, %rdx
    salq %rax
    salq %rbx //double a and b
    start2:
    mov y1, %rcx
    cmpq y, %rcx
    jl end
    call plot
    cmp $0,%rdx#check if y needs to be incremented
    jg ifninc2
    incq (x)
    add %rax, %rdx
    ifninc2:
    incq (y)
    add %rbx, %rdx
    jmp start2
o7:
    movq %rax,%rdx //d=2b-a
    salq %rdx
    subq %rbx, %rdx
    salq %rax
    salq %rbx //double a and b
    start7:
    mov x1, %rcx
    cmpq x, %rcx
    jl end
    call plot
    cmp $0,%rdx#check if y needs to be decremented
    jl ifninc7
    decq (y)
    sub %rbx, %rdx
    ifninc7:
    incq (x)
    add %rax, %rdx
    jmp start7
o8:
    movq %rax,%rdx //d=2a-b
    salq %rdx
    subq %rbx, %rdx
    salq %rax
    salq %rbx //double a and b
    start8:
    mov y1, %rcx
    cmpq y, %rcx
    jg end
    call plot
    cmp $0,%rdx#check if y needs to be incremented
    jg ifninc8
    incq (x)
    add %rax, %rdx
    ifninc8:
    decq (y)
    sub %rbx, %rdx
    jmp start8
    end:
    ret
plot:
#plot x,y
    mov y, %r8//this will be the index
    sal $9, %r8
    add x, %r8
    imul $3, %r8
    lea data,%rcx
    add %rcx, %r8
//color the pixel :)
    movzbw colorR, %cx
    movb %cl, 0(%r8)
    movzbw colorG, %cx
    movb %cl, 1(%r8)
    movzbw colorB, %cx
    movb %cl, 2(%r8)
//Plotting done 
    ret

