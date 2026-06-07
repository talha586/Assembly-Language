;24L-0618
[org 0x0100]

jmp start
val : db 8 
start:
   mov al,[val]
loop1:   
   shr al,1
   jc endprgrm
   cmp al,1
   je change   
jmp loop1

change:
  mov dx,1

endprgrm:
  mov dx,0
  mov ax,0x4c00
  int 0x21

