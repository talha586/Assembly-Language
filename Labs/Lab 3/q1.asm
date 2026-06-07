;24L-0618

[org 0x0100]

jmp start

array1 : dw 1,2,3,4,5,6
array2 : dw 0,0,0,0,0,0
size : dw 6

start:

      mov bx, array1
      mov si, array2
      mov cx,[size]

 l1:   add bx,2
       sub cx,1
       jnz l1

       sub bx,2
       mov cx,[size]

 l2: mov ax,[bx]
     mov [si],ax
     add si,2
     sub bx,2
     sub cx,1
     jnz l2
    
mov ax,0x4c00
int 0x21