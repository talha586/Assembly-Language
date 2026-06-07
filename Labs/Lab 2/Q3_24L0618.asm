;24L-0618
[org 0x0100]

mov ax,0
mov cx,[N]
l1 : add ax,[N]
sub cx,1
jnz l1
mov [square],ax

mov ax,0x4c00
int 0x21


N : dw 5
square : dw 0