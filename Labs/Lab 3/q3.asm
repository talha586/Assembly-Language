[org 0x0100]

jmp start

array   dw 2,4,2,5,4
size    dw 5

start:
    mov si, array       
    mov di, array          
    mov cx, [size]     
    
next:
    mov ax, [si]           
    mov bx, array
    mov dx, di           
    mov bp, 0            

checkloop:
    cmp bx, dx
    je checkdone
    cmp [bx], ax
    je duplicate
    add bx, 2
    jmp checkloop

duplicate:
    mov bp, 1
    jmp checkdone

checkdone:
    cmp bp, 1
    je skipstore

    mov [di], ax
    add di, 2

skipstore:
    add si, 2
    dec cx
    jmp next

fillzeros:
    mov bx, di
    mov dx, array
    add dx, [size]
    add dx, [size]        

zeroloop:
    cmp bx, dx
    je terminate
    mov word [bx], 0
    add bx, 2
    jmp zeroloop

terminate:
    mov ax, 0x4c00
    int 0x21
