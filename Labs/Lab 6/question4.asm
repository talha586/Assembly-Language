; [org 0x0100]
; jmp start

; top:    dw 2
; left:   dw 10
; bottom: dw 20
; right:  dw 60

; clrscr:
    ; push es
    ; push ax
    ; push di

    ; mov ax, 0xb800
    ; mov es, ax
    ; mov di, 0

; nextPos:
    ; mov word [es:di], 0x0720  
    ; add di, 2
    ; cmp di, 4000
    ; jne nextPos

    ; pop di
    ; pop ax
    ; pop es
    ; ret

; PrintRectangle:
    ; push bp
    ; mov bp, sp
    ; push es
    ; push ax
    ; push bx
    ; push cx
    ; push dx
    ; push si
    ; push di

    ; mov ax, 0xb800
    ; mov es, ax

    ; mov bl, 0x02             

    ; mov dx, [bp+10]          

; loop1:
    ; mov cx, [bp+6]         
; loop2:
    ; mov ax, dx
    ; mov si, 160             
    ; mul si
    ; add ax, cx
    ; shl ax, 1
    ; mov di, ax

    ; mov byte [es:di], ' '    
    ; mov byte [es:di+1], bl   

    ; inc cx
    ; cmp cx, [bp+4]          
    ; jle loop2

    ; inc dx
    ; cmp dx, [bp+8]           
    ; jle loop1

    ; pop di
    ; pop si
    ; pop dx
    ; pop cx
    ; pop bx
    ; pop ax
    ; pop es
    ; pop bp
    ; ret 8

; start:
    ; call clrscr

    ; mov ax, [right]
    ; push ax
    ; mov ax, [left]
    ; push ax
    ; mov ax, [bottom]
    ; push ax
    ; mov ax, [top]
    ; push ax
    ; call PrintRectangle

    ; mov ax, 0x4c00
    ; int 0x21
