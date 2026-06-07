[org 0x0100]
jmp start

Packed:  db 0ABh, 03Ch, 07Fh
HighNib: db 0,0,0
LowNib:  db 0,0,0
Count:   dw 3

SplitNibbles:
    push bp
    mov  bp,sp

    mov  si,[bp+10]    
    mov  di,[bp+8]     
    mov  bx,[bp+6]     
    mov  cx,[bp+4]     

split_loop:
    mov  al,[si]       
    mov  ah,al        

    and  al,0F0h       
    shr  al,4         
    mov  [di],al      

    and  ah,0Fh        
    mov  [bx],ah      

    inc  si
    inc  di
    inc  bx
    loop split_loop

    pop  bp
    ret 8             

start:
   
    push word [Count]
    mov ax, LowNib
    push ax
    mov ax, HighNib
    push ax
    mov ax, Packed
    push ax

    call SplitNibbles

    mov ax,0x4c00
    int 0x21
