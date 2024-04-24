# PLT trampoline for lazy binding
    .text
    .globl trampoline
    .hidden trampoline
    .type trampoline, @function
    .align 16

trampoline:

# Your code here
push %rbp
mov %rsp, %rbp

mov 0x10(%rbp), %rsi
mov 0x8(%rbp), %rdi
call runtimeResolve

movl 0x2c(%rbp), %edi
movl 0x28(%rbp), %esi  

mov %rbp, %rsp
pop %rbp
add $0x10, %rsp
jmpq *%rax
# Your code here


