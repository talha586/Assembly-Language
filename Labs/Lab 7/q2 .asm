; [org 0x0100]

; jmp start
; message : db 'Test String$',0

; CalculateLength:
    ; push bp
	; mov bp,sp
	; push es
	; push ax
	; push cx
	; push di
	
	; push ds
	; pop es
	; mov di,[bp+4]
	; mov cx,0xffff
	; xor al,al
	; repne scasb
	; mov ax,0xffff
	; sub ax,cx
	; dec ax	
    
; done:

    ; pop di
    ; pop cx
	; pop ax
	; pop es
	; mov sp,bp
	; pop bp
	
; ret 2

; start:
    ; mov ax,message
	; push ax
	; call CalculateLength
	
; mov ax,0x4c00
; int 0x21