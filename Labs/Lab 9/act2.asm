[org 0x0100]

jmp start

string : db 'He has food and drinks',0
old_isr : dd 0

ClearScreen:
    push es
    push ax
    push cx
    push di

    mov  ax, 0xb800
    mov  es, ax           
    xor  di, di           
    mov  ax, 0x0720      
    mov  cx, 2000         
    cld
    rep  stosw           

    pop  di
    pop  cx
    pop  ax
    pop  es
    ret
	
PrintMsg:
    push bp
	mov bp,sp
    push ax
	push cx
	push es
	push di
	push si
	
	mov ax,0xb800
	mov es,ax
	mov di,160
	mov si,[bp+6]
	mov cx,[bp+4]
	mov ah,0x07
	
	cld
nextChar:
    lodsb
    stosw
    loop nextChar	
	
    pop si
	pop di
	pop es
	pop cx
	pop ax
	mov sp,bp
	pop bp
ret 4	

Printdna:
    push bp
	mov bp,sp
	push cx
	push ax
	push bx
	
	mov cx,[bp+4]
	mov ax,0
	mov bx,[bp+6]
	
	loop1:
	
	cmp word [bx],'a'
	je check
	cmp word [bx],'A'
	jne change
	
	check:
	    cmp word [bx+1],'n'
		jne change
		cmp word [bx+2],'d'
		jne change
		
		mov [bx],dx
		mov [bx +2],ax
		mov [bx+2],dx
		mov [bx],ax
		add bx,3
		sub cx,3
		jnz loop1
		cmp cx,0
		jmp done
		
	change:
        inc bx
        loop loop1
    
    done:
    mov ax, bx
	push ax
	mov ax,cx
	push ax
	call PrintMsg
	
	pop bx
	pop ax
	pop cx
	mov sp,bp
	pop bp
	
Printhas:
	push bp
	mov bp,sp
	push cx
	push ax
	push bx
	
	mov cx,[bp+4]
	mov ax,0
	mov bx,[bp+6]
	
	loop2:
	
	cmp word [bx],'H'
	je check2
	cmp word [bx],'h'
	jne change2
	
	check2:
	    cmp word [bx+1],'a'
		jne change2
		cmp word [bx+2],'s'
		jne change2
		
		mov [bx],dx
		mov [bx +2],ax
		mov [bx+2],dx
		mov [bx],ax
		add bx,3
		sub cx,3
		jnz loop2
		cmp cx,0
		jmp done2
		
	change2:
        inc bx
        loop loop2
    
    done2:
    mov ax, bx
	push ax
	mov ax,cx
	push ax
	call PrintMsg
	
	pop bx
	pop ax
	pop cx
	mov sp,bp
	pop bp
	
my_isr:
    push ax
	push es
	
	call ClearScreen
	
	mov ax,0xb800
	mov es,ax
	
	in al,0x60
	cmp al, 0x2a
	jne nextcomp
	mov ax,string
	push ax
	mov ax,23
	push ax
	call Printdna
	jmp terminate
	
nextcomp:	
	cmp al,0x36
	jne nextcomp2
	mov ax,string
	push ax
	mov ax,23
	push ax
	call Printhas
    jmp terminate

nextcomp2:
    cmp al, 0xaa
	jne nextcomp3
	call ClearScreen
	jmp terminate
	
nextcomp3:
    cmp al, 0xb6
	jne no_match
	call ClearScreen	
	jmp terminate
	
no_match:
	pop es
	pop ax
    jmp far[es:old_isr]

terminate:
    mov al,0x20
	out 0x20,al
	
	pop es
	pop ax
	iret

start:
    
	xor ax,ax
	mov es,ax
	
	mov ax,[es:9*4]
	mov [old_isr],ax
	mov ax,[es:9*4 + 2]
	mov [old_isr + 2],ax
	
	cli 
	mov word [es:9*4],my_isr
	mov word [es:9*4+2],cs
	sti
	
	jmp $
	
	mov dx,start
	add dx,15
	mov cl,4
	shr dx,cl

mov ax,0x3100
int 0x21


