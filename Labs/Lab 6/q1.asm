[org 0x0100]

jmp start

base: db 2
power: db 3
result: dw 0

FindPower:
  push bp
  mov bp,sp
  push ax
  push cx
  push si

  mov cx,[bp+6]  ;power
  mov al,[bp+8]  ;base
  mov bl,[bp+8]
  mov si,[bp+4]  ;result
  mov ah,0
  mov bh,0

  dec cx
  
loop1:
  mul bl
  dec cx
  jnz loop1

  mov [si],ax

done:
  pop si
  pop cx
  pop ax
  mov sp,bp
  pop bp

ret 6
 
start:
   mov ah,0
   mov al,[base]
   push ax
   mov al,[power]
   push ax
   mov ax, result
   push ax
   
call FindPower

mov ax,0x4c00
int 0x21
