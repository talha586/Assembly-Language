;24L-0618
[org 0x100]
jmp start
value : dw 8
result : dw 0
start:
    mov ax,[value]
    mov dx,[result]
    ROR ax,1
    jc loop2
    mov dx,1
jmp end
loop2:
    mov dx,0
end:
   mov ax,0x4c00
   int 0x21


