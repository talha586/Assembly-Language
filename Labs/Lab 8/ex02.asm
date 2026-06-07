
; [org 0x0100]

; jmp start

; msg1: db 'hello world', 0
; msg2: db 'hello world again', 0
; msg3: db 'hello world again and again', 0

; clrscr:
    ; push es
    ; push ax
    ; push cx
    ; push di

    ; mov  ax, 0xb800
    ; mov  es, ax           ; point ES to video memory
    ; xor  di, di           ; point to top-left corner
    ; mov  ax, 0x0720       ; space char with normal attribute
    ; mov  cx, 2000         ; number of screen positions
    ; cld
    ; rep  stosw            ; clear the screen

    ; pop  di
    ; pop  cx
    ; pop  ax
    ; pop  es
    ; ret

; start:
    ; mov  ah, 0            ; wait for key
    ; int  0x16

    ; call clrscr           ; clear the screen

    ; mov  ah, 0
    ; int  0x16

    ; ; Print msg1
	; mov ah,0x13
	; mov al,1
	; mov bh,0
	; mov bl,0x1
	; mov dx , 0x0000
	; mov cx,11
	; push cs
	; pop es
	; mov bp,msg1
	; int 0x10

    ; mov  ah, 0
    ; int  0x16

    ; ; Print msg2
	
 	; mov ah,0x13
	; mov al,1
	; mov bh,0
	; mov bl,0x71
	; mov dx , 0x0000
	; mov cx,17
	; push cs
	; pop es
	; mov bp,msg2
	; int 0x10

    ; mov  ah, 0
    ; int  0x16

    ; ; Print msg3
 	; mov ah,0x13
	; mov al,1
	; mov bh,0
	; mov bl,0xF4
	; mov dx , 0x0000
	; mov cx,27
	; push cs
	; pop es
	; mov bp,msg3
	; int 0x10

    ; mov  ah, 0
    ; int  0x16

    ; mov  ax, 0x4C00       ; terminate program
    ; int  0x21