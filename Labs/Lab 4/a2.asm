;24L-0618
[org 0x0100]
jmp start
size: db 4
value: db 0xAB
start:     
     mov cl, [size]    
     mov al, [value]
rotate:
     ROR al,1
     sub cl,1 
     jnz rotate     
    
mov ax, 0x4c00
int 0x21