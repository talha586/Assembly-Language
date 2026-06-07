;24L-0618
[org 0x0100]

jmp start
result : dw  0
array : dw  1,2,3,2,1
size : dw  5

start:

mov cx,[size]
mov si,array
mov di,array

add di,cx
add di,cx
sub di,2

l1:
  mov ax,[si]
  mov dx,[di]
  cmp ax,dx
  jnz terminate

add si,2
sub di,2
sub cx,1
jnz l1

mov word[result],1

terminate:
mov word[result],0

mov ax,0x4c00
int 0x21



     


