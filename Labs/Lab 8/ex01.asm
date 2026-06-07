; ; Infinite Key Printing (Exit cleanly on ESC)
; [org 0x0100]
; jmp start

; ;------------------------------------------------

; ClrScr:
    ; push ax
	; push di
	; push es
	; push cx
	
	; mov ax,0xb800
	; mov es,ax
	; mov di,0
	; mov cx,4000
	
	; loop1:
	; mov word[es:di],0x0720
	; add di,2
	; loop loop1
	
	; pop cx
	; pop es
	; pop di
	; pop ax
	; ret 

; printKey:
    ; push ax
    ; push bx
    ; push cx
    ; push di
    ; push es

    ; mov ax, 0xb800
    ; mov es, ax         ; point ES to video memory
    ; xor di, di         ; start at top-left corner

    ; mov al, bl         ; AL = character to display

    ; mov ah, 0x07       ; attribute (white on black)
    ; mov cx, 2000       ; 80x25 characters

    ; cld
    ; rep stosw          ; fill screen with character
; done:

    ; pop es
    ; pop di
    ; pop cx
    ; pop bx
    ; pop ax
    ; ret
; ;------------------------------------------------

; start:
    ; mov ah, 0          ; BIOS keyboard service 0 - get key
    ; int 0x16           ; wait for key press
    ; cmp al, 27    
    ; je exitProgram     ; if ESC, exit immediately (don’t print)
    
    ; mov bl, al         ; otherwise, store key in BL
    ; call printKey      ; fill screen with the key
    ; jmp start          ; repeat

; ;------------------------------------------------
; exitProgram:
    ; call ClrScr
    ; mov ax, 0x4C00
    ; int 0x21
