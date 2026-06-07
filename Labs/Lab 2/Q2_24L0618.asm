[org 0x0100]

mov ax,0
mov dx,2
mov cx,[s]
mov si,a

l1: cmp dx,[si]
jne l3
l2: add ax,1
l3: add si,2

sub cx,1
jnz l1

mov ax,0x4c00
int 0x21

s : dw 5
a : dw 2,4,2,8,5