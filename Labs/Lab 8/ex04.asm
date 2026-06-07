[org 0x0100]

keycount: dw 0
oldisr: dd 0

jmp start

clrscr:
    push es
    push ax
    push cx
    push di
    
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, 0x0720
    mov cx, 2000
    cld
    rep stosw
    
    pop di
    pop cx
    pop ax
    pop es
    ret

Count:
    push es
    push ax
    push bx
    push cx
    push di
    push si
    
    mov ax, 0xb800
    mov es, ax
    mov ax, 80
    mov bl, 24
    mul bl
    shl ax, 1
    mov di, ax
   ; mov si, message
    mov ah, 0x07
DisplayText:
    lodsb
    cmp al, 0
    je printcount
    stosw
    jmp DisplayText
    
printcount:
    mov ax, [keycount]
    mov bx, 10
    mov cx, 0
    
conversion:
    xor dx, dx
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz conversion
    
displaydigits:
    pop ax
    mov ah, 0x07
    stosw
    loop displaydigits
    
    pop si
    pop di
    pop cx
    pop bx
    pop ax
    pop es
    ret

NewInt9:
    push ax
    push bx
    push es
    
    in al, 0x60
    test al, 0x80
    jnz skip_count
    inc word [keycount]
    call Count
    
skip_count:
    mov al, 0x20
    out 0x20, al
    
    pop es
    pop bx
    pop ax
    jmp far [cs:oldisr]

;message: db 'Key Presses: ', 0

start:
    call clrscr
    mov ax, 0
    mov es, ax
    mov ax, [es:9*4]
    mov [oldisr], ax
    mov ax, [es:9*4+2]
    mov [oldisr+2], ax
    cli
    mov word [es:9*4], NewInt9
    mov word [es:9*4+2], cs
    sti
    call Count
    mov dx, start
    add dx, 15
    mov cl, 4
    shr dx, cl
    mov ax, 0x4c00
    int 0x21