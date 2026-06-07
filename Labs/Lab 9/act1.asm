; [org 0x0100]

; jmp start

; msg_a : db 'Hi, You pressed a.'
; msg_b : db 'Hi, You pressed b.'
; msg_invalid: db 'Hi, You entered wrong credentials.'

; ClearScreen:
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

; PrintMsg:
    ; push bp
	; mov bp,sp
    ; push ax
	; push cx
	; push es
	; push di
	; push si
	
	; mov ax,0xb800
	; mov es,ax
	; mov di,160
	; mov si,[bp+6]
	; mov cx,[bp+4]
	; mov ah,0x07
	
	; cld
; nextChar:
    ; lodsb
    ; stosw
    ; loop nextChar	
	
    ; pop si
	; pop di
	; pop es
	; pop cx
	; pop ax
	; mov sp,bp
	; pop bp
; ret 4
   
; start:

    ; mov ah,0x00
    ; int 0x16
    ; call ClearScreen
    ; mov ah,0x00
    ; int 0x16
	
	; cmp al,'a'
	; jne CompareB

; CompareA:
    ; mov ax,msg_a
	; push ax
	; mov ax,18
	; push ax
	; call PrintMsg  
	; jmp done
    
; CompareB:
    ; cmp al,'b'
	; jne loop1 
	
	; mov ax,msg_b
	; push ax
	; mov ax,18
	; push ax	
	; call PrintMsg   
	; jmp done	
; loop1:	
    ; mov ax,msg_invalid
	; push ax
	; mov ax,33
	; push ax
	; call PrintMsg

; done:

    ; mov ax,0x4c00
    ; int 0x21 	