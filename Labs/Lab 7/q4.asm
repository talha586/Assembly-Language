; [org 0x0100]
; jmp start

; Source: db 'This is a test block.'
; Destination: db 20
; message: db 'The first 20 byte of source are copied to the destination buffer$'

; clearscreen:
    ; push ax
    ; push cx
    ; push di
    ; push es
    
    ; mov ax, 0xB800
    ; mov es, ax
    ; mov di, 0
    ; mov cx, 2000
    ; mov ax, 0x0720
    
    ; rep stosw
    
    ; pop es
    ; pop di
    ; pop cx
    ; pop ax

; copydata:
    ; push bp
    ; mov bp, sp
    ; push si
    ; push di
    ; push cx
    ; push es
    
    ; mov si, [bp+6]
    ; mov di, [bp+4]
    ; mov cx, 20
    ; push ds
    ; pop es
    ; rep movsb
    
    ; pop es
    ; pop cx
    ; pop di
    ; pop si
    ; pop bp
    ; ret 4

; print:
    ; push bp
    ; mov bp, sp
    ; push si
    ; push di
    ; push ax
    ; push es
    
    ; mov ax, 0xB800
    ; mov es, ax
    ; mov di, 0
    ; mov si, [bp+4]
    ; mov ah, 0x07

; print_loop:
    ; mov al, [si]
    ; cmp al, '$'
    ; je done
    ; mov [es:di], ax
    ; inc si
    ; add di, 2
    ; jmp print_loop
    
; done:
    ; pop es
    ; pop ax
    ; pop di
    ; pop si
    ; pop bp
    ; ret 2

; start:
    ; call clearscreen
    ; mov ax, Source
    ; push ax
    ; mov ax, Destination
    ; push ax
    ; call copydata
    
    ; mov ax, message
    ; push ax
    ; call print
    
    ; mov ax, 0x4c00
    ; int 0x21