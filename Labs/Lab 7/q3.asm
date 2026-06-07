; [org 0x0100]
; jmp start

; String: db 'Hello World!', 0
; pointer: dd String
; result: db 13
; message: db 'Copied Data',0

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
    ; ret

; copy_string:
    ; push bp
    ; mov bp, sp
    ; push si
    ; push di
    ; push cx
    ; push es
    
    ; lds si, [pointer]
    ; mov di, [bp+4]
    ; mov cx, 12
    
; copy_loop:
    ; mov al, [si]
    ; mov [di], al
    ; inc si
    ; inc di
    ; loop copy_loop
    
    ; mov byte [di], 0
    
    ; pop es
    ; pop cx
    ; pop di
    ; pop si
    ; pop bp
    ; ret 2

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
    ; mov ax, result
    ; push ax
    ; call copy_string
    
    ; mov ax, String
    ; push ax
    ; call print
    
    ; mov ax, 0x4c00
    ; int 0x21