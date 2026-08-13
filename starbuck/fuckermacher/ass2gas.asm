section .data
    ; Define JSON strings
    json_true db "true", 0
    json_int db "42", 0
    json_float db "3.14", 0
    json_string db '"hello"', 0
    json_array db '["apple","banana","cherry"]', 0
    json_object db '{"name":"John","age":30}', 0

    ; Format strings for printing
    fmt_str db "%s", 10, 0

section .text
    global main
    extern printf

main:
    ; Print JSON representations
    push json_true
    push fmt_str
    call printf
    add esp, 8

    push json_int
    push fmt_str
    call printf
    add esp, 8

    push json_float
    push fmt_str
    call printf
    add esp, 8

    push json_string
    push fmt_str
    call printf
    add esp, 8

    push json_array
    push fmt_str
    call printf
    add esp, 8

    push json_object
    push fmt_str
    call printf
    add esp, 8

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80
