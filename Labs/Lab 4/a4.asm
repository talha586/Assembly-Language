;24L-0618
[org 0x0100]
jmp start

num: dw 0x6F2B        
BitCount: dw 0        
size: dw 16           

start:
    mov ax, [num]    
    mov cx, [size]    
    mov bx, 0        

loop1:
    ROR ax, 1         
    jnc skip_increment 
    add bx,1           

skip_increment:
    sub cx,1            
    jnz loop1         

    mov [BitCount], bx 

    mov ax, 0x4C00    
    int 0x21
 
