section .data
    num1 db 30      ; First number to add
    num2 db 100      ; Second number to add
    result db 0    ; Storage for the result
    output db '00', 0    ; Buffer to store ASCII representation of result

section .bss

section .text
    global _start

_start:
    ; Load numbers into registers
    mov al, [num1]
    add al, [num2]
    mov [result], al

    ; Convert result to ASCII
    movzx rax, byte [result]  ; Move the result into RAX and zero-extend it

    ; Check if result is greater than 9
    cmp rax, 9
    jle single_digit

    ; Convert to ASCII for numbers >= 10
    mov rbx, 10          ; Divider for base 10
    xor rdx, rdx         ; Clear RDX for division
    div rbx              ; Divide RAX by 10; quotient in RAX, remainder in RDX
    add dl, '0'          ; Convert remainder to ASCII
    mov [output+1], dl   ; Store remainder ASCII character in output buffer
    add al, '0'          ; Convert quotient to ASCII
    mov [output], al     ; Store quotient ASCII character in output buffer
    mov edx, 2           ; Length of the string is 2 characters
    jmp print_result

single_digit:
    add al, '0'          ; Convert single digit to ASCII
    mov [output], al     ; Store ASCII character in output buffer
    mov byte [output+1], 0 ; Null terminate the string
    mov edx, 1           ; Length of the string is 1 character

print_result:
    ; Write the result to stdout
    mov eax, 1           ; sys_write system call number
    mov edi, 1           ; file descriptor (stdout)
    lea rsi, [output]    ; Load address of output buffer into RSI
    syscall              ; call kernel

    ; Exit the program
    mov eax, 60          ; sys_exit system call number
    xor edi, edi         ; exit code 0
    syscall              ; call kernel

