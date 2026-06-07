; [org 0x0100]

; jmp start

; base: db 2
; limit: db 8
; temp:  dw 0
; result: dw 0

; FindPower:
  ; push bp
  ; mov bp,sp
  ; push ax
  ; push cx
  ; push si

  ; mov cx,[bp+6]
  ; mov al,[bp+8]
  ; mov bl,[bp+8]
  ; mov si,[bp+4]
  ; mov ah,0
  ; mov bh,0
  ; dec cx
; loop1:
  ; mul bl
  ; dec cx
  ; jnz loop1
  ; mov [si],ax
; done:
  ; pop si
  ; pop cx
  ; pop ax
  ; mov sp,bp
  ; pop bp
; ret 6

; SeriesSum:
  ; push bp
  ; mov bp,sp
  ; push ax
  ; push bx
  ; push cx
  ; push dx
  ; push si
  ; push di

  ; mov al,[bp+6]
  ; mov bl,[bp+4]

  ; mov si,temp
  ; mov di,result
  ; mov word [di],0
  ; mov cl,1

; sum_loop:
  ; cmp cl,bl
  ; ja sum_done

  ; mov ax,si
  ; push ax
  ; mov ah,0
  ; mov al,cl
  ; push ax
  ; mov ah,0
  ; mov al,[bp+6]
  ; push ax
  ; call FindPower

  ; mov ax,[si]
  ; add [di],ax

  ; inc cl
  ; jmp sum_loop

; sum_done:
  ; mov ax,[di]
  ; push ax

  ; pop di
  ; pop si
  ; pop dx
  ; pop cx
  ; pop bx
  ; pop ax
  ; mov sp,bp
  ; pop bp
; ret 4

; start:
   ; mov ah,0
   ; mov al,[limit]
   ; push ax
   ; mov ah,0
   ; mov al,[base]
   ; push ax
   ; call SeriesSum
   ; pop ax
   ; mov [result],ax
   ; mov ax,0x4c00
   ; int 0x21
