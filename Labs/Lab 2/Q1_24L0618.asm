[org 0x0100]

mov ax,0
mov cx,[N]
l1: add ax , cx
sub cx,1
jnz l1
mov ax,0x4c00
int 0x21

N : dw 6