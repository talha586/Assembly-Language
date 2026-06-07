[org 0x0100]
start:
    
	mov ax, 0003h
    int 10h
    
	mov ax, 0B800h
    mov es, ax
	
	call draw_bubbles
    call draw_player
	
	mov ax, ScoreText
	push ax
	call drawScore
	call update_score

game_loop:

    mov cx, 04000h
	
delay:

    loop delay
    
	mov ah, 01h
    int 16h
	jz update_bullet
    
	mov ah, 00h
    int 16h
	
    cmp al, 1Bh
    je exit_game
	
    cmp ah, 4Bh
    je move_left
	
    cmp ah, 4Dh
    je move_right
    cmp ah, 48h
    je fire_bullet
	
    jmp update_bullet
	
	
move_left:

    cmp word [player_x], 0
    jle update_bullet
    
	call clear_player
	
    dec word [player_x]
    
	call draw_player
    
	jmp update_bullet
move_right:

    cmp word [player_x], 79
    jge update_bullet
    
	call clear_player
    inc word [player_x]
    
	call draw_player
    jmp update_bullet
fire_bullet:

    cmp byte [bullet_active], 1
    je update_bullet
    
	mov ax, [player_x]
    mov [bullet_x], ax
    mov word [bullet_y], 23
    mov byte [bullet_active], 1
    
	call draw_bullet_char
    jmp update_bullet
update_bullet:

    cmp byte [bullet_active], 1
    jne game_loop
    
	call erase_bullet_char
	
    dec word [bullet_y]
    cmp word [bullet_y], 0
    jl kill_bullet
    
	call get_screen_offset_bullet
	
    mov al, [es:di]
    cmp al, 'O'
    
	je hit_bubble
	
    call draw_bullet_char
    
	jmp game_loop
	
hit_bubble:
    
	mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    mov byte [bullet_active], 0
    
	inc word[score]
	
	call update_score
	
	jmp game_loop
	
kill_bullet:
    
	mov byte [bullet_active], 0
    
	jmp game_loop

exit_game:
    
	mov ax, 4C00h
    int 21h
	

draw_bubbles:

    xor di, di
    mov cx, 240
	
fill_bubbles:

    mov byte [es:di], 'O'
    mov byte [es:di+1], 03h
    add di, 2
	
    loop fill_bubbles
    
	ret
	
draw_player:

    call get_screen_offset_player
	
    mov byte [es:di], 254
    mov byte [es:di+1], 0Eh
    ret

clear_player:

    call get_screen_offset_player
	
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    ret

draw_bullet_char:

    call get_screen_offset_bullet
	
    mov byte [es:di], 24h
    mov byte [es:di+1], 0Ch
    ret

erase_bullet_char:

    call get_screen_offset_bullet
	
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    ret

get_screen_offset_player:

    mov ax, 24
    mov bx, 80
    mul bx
    add ax, [player_x]
    shl ax, 1
    mov di, ax
    ret

get_screen_offset_bullet:

    mov ax, [bullet_y]
    mov bx, 80
    mul bx
    add ax, [bullet_x]
    shl ax, 1
    mov di, ax
    ret
	
drawScore:
    push bp
	mov bp,sp
	push si
	push di
	push ax
	
	mov si,[bp+4]
	
	mov ax,0xb800
	mov es,ax
	
	mov di,3840
	
	mov cx,6
	
PrintScore:	
	mov dl,[si]
	mov dh,0x30
	mov [es:di],dx
	add di,2
	add si,1
	loop PrintScore
	
    pop ax
	pop di
	pop bx
	pop si
	mov sp,bp
	pop bp
	
	ret 4	

update_score:
    push ax
    push bx
	push dx
	push di
	push cx
	
	mov ax,[score]
	mov bx,10
	mov cx,0
	
	mov di, 3854
	
Get_Score:
    mov dx,0
    div bx	
    add dl,0x30
	push dx
	inc cx
	cmp ax,0
	jnz Get_Score
	
Print_Value:
    pop dx
	mov dh,0x30
	mov [es:di],dx
	add di,2
	loop Print_Value
    
	pop cx
	pop di
	pop dx
	pop bx
	pop ax
	
ret	
	
player_x: dw 40
bullet_x: dw 0
bullet_y: dw 0
bullet_active: db 0
ScoreText: db 'Score: '
score: dw 0


