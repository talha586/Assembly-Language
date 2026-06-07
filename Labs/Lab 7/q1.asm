; [org 0x0100]
; jmp start

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

; start:
    ; call clearscreen
    ; mov ax, 0xB800
    ; mov es, ax
    ; mov di, 12 * 80 * 2
    ; mov ax, 0x0E2D
    ; mov cx, 80
    ; rep stosw

    ; mov ax, 0x4c00
    ; int 0x21