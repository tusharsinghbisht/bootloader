[BITS 16]
[ORG 0x7c00] 

CODE_OFFSET equ 0x8
DATA_OFFSET equ 0x10

start:
    cli ; Clear interrupts 
    mov ax, 0x00
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti ; Enable interrupts
    ; mov si, msg

; print: 
;     lodsb ; loads byte at address ds:si to AL register and increments SI
;     cmp al, 0 ; if null char
;     je done
;     mov ah, 0x0E
;     int 0x10
;     jmp print

load_PM:
    cli
    lgdt[gdt_descriptor]
    mov eax, cr0
    or al, 1
    mov cr0, eax
    jmp CODE_OFFSET: PModeMain


done:
    cli
    hlt ; Stop CPU for further execution

;msg: db "Benzo ka bootloader", 0 ; 0 in end is null char in string


; GDT implementation
gdt_start:
    dd 0x0
    dd 0x0

    ; Code segment descriptor
    dw 0xFFFF    ; Limte
    dw 0x0000    ; Base
    db 0x00      ; Base
    db 10011010b ; Access byte
    db 11001111b ; Flags
    db 0x00      ; Base

    ; Data segment descriptor
    dw 0xFFFF    ; Limte
    dw 0x0000    ; Base
    db 0x00      ; Base
    db 10010010b ; Access byte
    db 11001111b ; Flags
    db 0x00      ; Base

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1; Size of GDT - 1
    dd gdt_start

[BITS 32]
PModeMain:
    mov ax, DATA_OFFSET
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov gs, ax
    mov ebp, 0x9C00 
    mov esp, ebp

    in al, 0x92
    or al, 2
    out 0x92, al
    
    jmp $


times 510 - ($ - $$) db 0

dw 0xAA55 ; last two bytes is to be 55 AA (0xAA55) in little endian