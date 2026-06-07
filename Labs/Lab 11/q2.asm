; [org 0x0100]
; jmp start

; pcb: times 32*16 dw 0
; stack: times 32*256 dw 0
; nextpcb: dw 1
; current: dw 0
; lineno: dw 0
; noietrations: dw 4

; mytask: push bp
; mov bp, sp
; sub sp, 2
; push ax
; push bx
; mov ax, [bp+4]
; mov bx, 0
; mov word [bp-2], 0

; printagain: push ax
; push bx
; push word [bp-2]
; call printnum
; inc word [bp-2]
; jmp printagain

; pop bx
; pop ax
; mov sp, bp
; pop bp
; ret

; initpcb: push bp
; mov bp, sp
; push ax
; push bx
; push cx
; push si

; mov bx, [nextpcb]
; cmp bx, 32
; je exit

; mov cl, 5
; shl bx, cl

; mov ax, [bp+8]
; mov [pcb+bx+18], ax
; mov ax, [bp+6]
; mov [pcb+bx+16], ax
; mov [pcb+bx+22], ds

; mov si, [nextpcb]
; mov cl, 9
; shl si, cl
; add si, 256*2+stack
; mov ax, [bp+4]
; sub si, 2
; mov [si], ax
; sub si, 2
; mov [pcb+bx+14], si

; mov word [pcb+bx+26], 0x0200

; mov ax,[noietrations]
; mov [pcb + bx + 30],ax

; mov ax, [pcb+28]
; mov [pcb+bx+28], ax
; mov ax, [nextpcb]
; mov [pcb+28], ax

; inc word [nextpcb]

; exit: pop si
; pop cx
; pop bx
; pop ax
; pop bp
; ret 6

; printnum: push bp
; mov bp, sp
; push es
; push ax
; push bx
; push cx
; push dx
; push di

; mov di, 80
; mov ax, [bp+8]
; mul di
; mov di, ax
; add di, [bp+6]
; shl di, 1
; add di, 8

; mov ax, 0xb800
; mov es, ax
; mov ax, [bp+4]
; mov bx, 16
; mov cx, 4

; nextdigit: mov dx, 0
; div bx
; add dl, 0x30
; cmp dl, 0x39
; jbe skipalpha
; add dl, 7

; skipalpha: mov dh, 0x07
; mov [es:di], dx
; sub di, 2
; loop nextdigit

; pop di
; pop dx
; pop cx
; pop bx
; pop ax
; pop es
; pop bp
; ret 6

; timer: push ds
; push bx
; push cs
; pop ds
; mov bx, [current]

; push bx
; mov cl, 5
; shl bx, cl
; pop bx

; mov [pcb+bx+0], ax
; mov [pcb+bx+4], cx
; mov [pcb+bx+6], dx
; mov [pcb+bx+8], si
; mov [pcb+bx+10], di
; mov [pcb+bx+12], bp
; mov [pcb+bx+24], es
; pop ax
; mov [pcb+bx+2], ax
; pop ax
; mov [pcb+bx+20], ax
; pop ax
; mov [pcb+bx+16], ax
; pop ax
; mov [pcb+bx+18], ax
; pop ax
; mov [pcb+bx+26], ax
; mov [pcb+bx+22], ss
; mov [pcb+bx+14], sp

; dec word [pcb + bx +30]
; jnz loop1

; push ax
; mov ax, [noietrations]
; mov [pcb + bx + 30], ax
; pop ax

; mov bx, [pcb+bx+28]
; mov [current], bx

; mov cl, 5
; shl bx, cl

; loop1:
; mov cx, [pcb+bx+4]
; mov dx, [pcb+bx+6]
; mov si, [pcb+bx+8]
; mov di, [pcb+bx+10]
; mov bp, [pcb+bx+12]
; mov es, [pcb+bx+24]
; mov ss, [pcb+bx+22]
; mov sp, [pcb+bx+14]
; push word [pcb+bx+26]
; push word [pcb+bx+18]
; push word [pcb+bx+16]
; push word [pcb+bx+20]

; mov al, 0x20
; out 0x20, al

; mov ax, [pcb+bx+0]
; mov bx, [pcb+bx+2]
; pop ds
; iret

; start:
; mov ax, 0003h
; int 10h

; xor ax, ax
; mov es, ax
; cli
; mov word [es:8*4], timer
; mov [es:8*4+2], cs
; sti

; nextkey:
; xor ah, ah
; int 0x16
; push cs
; mov ax, mytask
; push ax
; push word [lineno]
; call initpcb
; inc word [lineno]
; jmp nextkey
