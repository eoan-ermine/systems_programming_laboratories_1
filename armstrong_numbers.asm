section .data
    format: db '%d\n',10

global main
section .text

extern printf

pow:
    mov r10, rcx ; int number (arg)
    mov r11, rdx ; int power (arg)
    dec r11
    mov r9, r10 ; int original_number = number
    mov r8, 0 ; int i = 0
    mov rax, r10
__condition0:
    cmp r8, r11
    jne __loop0
    ret
__loop0:
    mov rax, r10
    mov rdx, r9
    mul rdx
    mov r10, rax
    inc r8
    jmp __condition0

number_of_digits:
    mov r8, rcx ; int number (arg)
    mov r9, 0 ; int i = 0
__condition1:
    cmp r8, 0
    jne __loop1
    mov rax, r9
    ret
__loop1:
    mov rax, r8
    cqo
    mov rcx, 10
    idiv rcx
    mov r8, rax
    inc r9
    jmp __condition1

main:
    mov rbp, rsp; for correct debugging
    mov r15, 1
 
 __loop3:
    mov rbx, r15 ; int original_number
    mov r12, r15 ; int number = 1
    mov r13, 0 ; int result = 0
    mov rcx, r12
    call number_of_digits
    mov r14, rax ; int i = number_of_digits(number)

__condition2:
    cmp r12, 0
    jne __loop2

    cmp rbx, r13
    je __print
    jmp __continue_iter

__print:
    mov rdi, format
    mov rsi, r13
    mov eax, 0
    call printf

__continue_iter:
    inc r15
    cmp r15, 0
    jne __loop3
    
    ret
__loop2:
    mov rax, r12
    cqo
    mov rcx, 10
    idiv rcx ; rax - результат, rdx - остаток
    mov r12, rax
    
    mov rcx, rdx
    mov rdx, r14
    call pow
    add r13, rax
    
    jmp __condition2
    
