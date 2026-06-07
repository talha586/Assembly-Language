;24L-0618
[org 0x0100]

jmp start
time : dw 2
array : dw 1,2,3,4,5
size : dw 5
counter: dw 0

start:
   mov si, array
   mov di, array
   add di, [size]
   add di, [size]
   sub di, 2           

   mov bx, [time]      

timing: 
      mov ax, [di]     
      mov cx, [size]
      sub cx, 1        
      mov bx, di       

shifting: 
      mov bp, [bx-2]   
      mov [bx], bp     
      sub bx, 2
      sub cx, 1
      jnz shifting

      mov [si], ax    

   sub word [time], 1
   jnz timing

mov ax, 0x4c00
int 0x21
