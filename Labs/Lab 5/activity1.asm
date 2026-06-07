[org 0x0100]

jmp start

array:       db 25, 17, 43, 9, 55
length:      db 5
small:       db 0
secondSmall: db 0

FindSecondSmallest:
    push bp
    mov  bp, sp
    push si
    push cx
    push bx
    push dx

    mov si, [bp+4]      
    mov cx, [bp+8]      
    mov al, [si]       
    mov bl, al          
    mov bh, 0FFh        

    inc si
    dec cx

next_elem:
    cmp cx, 0
    je done

    mov dl, [si]      

    cmp dl, bl
    jge check_second

    mov bh, bl
    mov bl, dl
    jmp cont_loop

check_second:
    cmp dl, bh
    jge cont_loop
    cmp dl, bl
    je cont_loop        
    mov bh, dl

cont_loop:
    inc si
    dec cx
    jmp next_elem

done:
    mov si, [bp+6]      
    mov [si], bl
    mov si, [bp+0Ah]    
    mov [si], bh

    pop dx
    pop bx
    pop cx
    pop si
    pop bp
    ret 8              
	
start:
    mov ax, array
    push ax             
    mov ax, small
    push ax             
    mov al, [length]    
    xor ah, ah          
    push ax            

    mov ax, secondSmall
    push ax             
    call FindSecondSmallest

    mov ax, 4C00h
    int 21h
