; [org 0x0100]

; count : db 0
; isr: dw 0

; jmp start

; clrscr:
    ; push es
    ; push ax
    ; push cx
    ; push di

    ; mov  ax, 0xb800
    ; mov  es, ax          
    ; xor  di, di           
    ; mov  ax, 0x0720       
    ; mov  cx, 2000         
    ; cld
    ; rep  stosw            

    ; pop  di
    ; pop  cx
    ; pop  ax
    ; pop  es
    ; ret

; FillScreen:
    ; push ax
	; push bx
	; push cx
	; push di
	; push es
	
	; mov ax,0xb800
	; mov es,ax
	; xor di,di
	; mov al,[count]
	; mov ah,0x07
	; mov cx,2000
	; cld
	; rep stosw
	
    ; inc byte [count]
    ; cmp byte [count],0
    ; jne done
    ; mov byte [count],0
	
; done:
	
    ; pop es
    ; pop di
    ; pop cx
    ; pop bx
    ; pop ax
	
    ; iret
	
; start:
    ; call clrscr
	; mov ax,0
	; mov es,ax
	; mov ax,[es:0*4]
	; mov [isr],ax
	; mov ax,[es:0*4+2]
	; mov [isr+2],ax
	; cli
	; mov word [es:0*4],FillScreen
	; mov word[es:0*4+2],cs
	; sti

		
; loop1:
    ; mov ax,1
	; xor bl,bl
	; div bl
	; jmp loop1
	
; mov ax,0x4c00
; int 0x21
