; [org 0x0100]
; jmp start

; String1: db 'P@ssword'
; String2: db 'P@ssword'

; EqualMsg: db 'Strings are equal$'
; NotEqualMsg: db 'Strings are not equal$'

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

; Identical:
    ; push bp
    ; mov bp, sp
    ; push si
    ; push di
    ; push cx
    ; push ax
    ; push es
    ; push bx
    
    ; mov si, [bp+6]
    ; mov di, [bp+4]
    
    ; push ds
    ; pop es
    
    ; mov cx, 8
    ; repe cmpsb
    
    ; mov ax, 0xB800
    ; mov es, ax
    ; mov di, 0
    
    ; jnz NotEqual
    
    ; mov si, EqualMsg
    ; jmp print
    
; NotEqual:
    ; mov si, NotEqualMsg
    
; print:
    ; mov ah, 0x07
	
; printloop:
    ; mov al, [si]
    ; cmp al, '$'
    ; je done
    ; mov [es:di], ax
    ; inc si
    ; add di, 2
    ; jmp printloop
    
; done:



    ; pop bx
    ; pop es
    ; pop ax
    ; pop cx
    ; pop di
    ; pop si
    ; pop bp
    ; ret 4

; start:
    ; call clearscreen
    ; mov ax, String1
    ; push ax
    ; mov ax, String2
    ; push ax
    ; call Identical
    
    ; mov ax, 0x4c00
    ; int 0x21