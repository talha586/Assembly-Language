[org 0x0100]

jmp start

result: dw 0       
countzero:

    push bp
    mov  bp,sp

    push ax
    push cx

    mov  ax,[bp+4]  
    xor  cx,cx      

loop:
    test ax,1       
    jnz  done   
    shr  ax,1       
    inc  cx          
    jmp  loop

done:
    mov [result],cx 

    pop  cx
    pop  ax
    pop  bp
    ret 2            

start:
    mov ax,0x2800    
    push ax
    call countzero

    mov ax,0x4c00
    int 0x21
