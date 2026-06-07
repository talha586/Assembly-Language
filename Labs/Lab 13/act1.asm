;24L-0618

[org 0x0100]

start:
    mov ax, 0003h
    int 10h

    mov ax, 0B800h
    mov es, ax
	
    call Start_Screen
	
	mov cx,0010h
delay_o:
    push cx 
	mov cx,0xFFFF
delay_i:
	loop delay_i
	pop cx
	loop delay_o
	
		mov cx,0010h
delay_o2:
    push cx 
	mov cx,0xFFFF
delay_i2:
	loop delay_i2
	pop cx
	loop delay_o2
	
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

    xor ax, ax
    mov es, ax

    mov ax, [es:08*4]
    mov [old_offset], ax
    mov ax, [es:08*4+2]
    mov [old_segment], ax

    cli
    mov word [es:08*4], timer
    mov word [es:08*4+2], cs
    sti

    mov ax, 0xB800
    mov es, ax

main:
    cmp byte [game_over], 1
    je exit_game

    mov cx, 0FFFFh

delay:
    loop delay

    mov ah, 01h
    int 16h
    jz update_bullet_logic

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

    jmp update_bullet_logic

move_left:
    cmp word [player_x], 0
    jle update_bullet_logic

    call clearPlayer
    dec word [player_x]
    call draw_player
    jmp update_bullet_logic

move_right:
    cmp word [player_x], 79
    jge update_bullet_logic

    call clearPlayer
    inc word [player_x]
    call draw_player
    jmp update_bullet_logic

fire_bullet:
    cmp byte [bulletActive], 1
    je update_bullet_logic

    mov ax, [player_x]
    mov [bullet_x], ax
    mov word [bullet_y], 23
    mov byte [bulletActive], 1

    call drawBullet
    jmp update_bullet_logic

update_bullet_logic:
    cmp byte [bulletActive], 1
    jne main

    call eraseBullet

    dec word [bullet_y]
    cmp word [bullet_y], 0
    jl deleteBullet

    call calc_bullet_pos

    mov al, [es:di]
    cmp al, 'O'
    je checkHit

    call drawBullet
    jmp main

checkHit:
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    mov byte [bulletActive], 0

    inc word[score]
    call update_score
    jmp main

deleteBullet:
    mov byte [bulletActive], 0
    jmp main

exit_game:
    mov ax, 0003h
    int 10h
	
	call Over_Screen
	
	mov cx,0010h
delay_o3:
    push cx 
	mov cx,0xFFFF
delay_i3:
	loop delay_i3
	pop cx
	loop delay_o3
	
	mov cx,0010h
delay_o4:
    push cx 
	mov cx,0xFFFF
delay_i4:
	loop delay_i4
	pop cx
	loop delay_o4
	
    xor ax, ax
    mov es, ax
    cli
    mov ax, [old_offset]
    mov [es:08*4], ax
    mov ax, [old_segment]
    mov [es:08*4+2], ax
    sti

    mov ax, 4C00h
    int 21h

timer:
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es

    push cs
    pop ds

    mov ax, 0B800h
    mov es, ax

    inc word [tick_count]
    cmp word [tick_count], 18
    jl end_timer

    mov word [tick_count], 0

    call move_bubbles_down

end_timer:
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    jmp far [cs:old_offset]

move_bubbles_down:
    mov di, 3838

check_bubble_loop:
    cmp di, 0
    jl finish_move

    mov al, byte [es:di]
    cmp al, 'O'
    jne next_cell

    mov bx, di
    add bx, 160

    cmp bx, 3840
    jae set_gameover

    mov byte [es:bx], 'O'
    mov byte [es:bx+1], 03h

    mov byte [es:di], ' '
    mov byte [es:di+1], 07h

next_cell:
    sub di, 2
    jmp check_bubble_loop

set_gameover:
    mov byte [game_over], 1
	
    jmp finish_move

finish_move:
    ret

draw_bubbles:
    xor di, di
    mov cx, 160
fill_bubbles:
    mov byte [es:di], 'O'
    mov byte [es:di+1], 03h
    add di, 2
    loop fill_bubbles
    ret

draw_player:
    call calc_player_pos
    mov byte [es:di], 254
    mov byte [es:di+1], 0Eh
    ret

clearPlayer:
    call calc_player_pos
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    ret

drawBullet:
    call calc_bullet_pos
    mov byte [es:di], 24h
    mov byte [es:di+1], 0Ch
    ret

eraseBullet:
    call calc_bullet_pos
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    ret

calc_player_pos:
    mov ax, 24
    mov bx, 80
    mul bx
    add ax, [player_x]
    shl ax, 1
    mov di, ax
    ret

calc_bullet_pos:
    mov ax, [bullet_y]
    mov bx, 80
    mul bx
    add ax, [bullet_x]
    shl ax, 1
    mov di, ax
    ret

drawScore:
    push bp
    mov bp, sp
    push si
    push di
    push ax
    push cx
    push dx

    mov si, [bp+4]

    mov ax, 0xb800
    mov es, ax

    mov di, 3840

    mov cx, 7

PrintScore:
    mov dl, [si]
    mov dh, 0x30
    mov [es:di], dx
    add di, 2
    inc si
    loop PrintScore

    pop dx
    pop cx
    pop ax
    pop di
    pop si
    mov sp, bp
    pop bp
    ret 2

update_score:
    push ax
    push bx
    push cx
    push dx
    push di

    mov ax, [score]
    mov bx, 10
    mov cx, 0

    mov di, 3854

Get_Score:
    mov dx, 0
    div bx
    add dl, 0x30
    push dx
    inc cx
    cmp ax, 0
    jnz Get_Score

Print_Value:
    pop dx
    mov dh, 0x30
    mov [es:di], dx
    add di, 2
    loop Print_Value

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret
	
Start_Screen:
    push bp
    mov bp, sp
    push si
    push di
    push cx
    push dx

    mov si, starttext

    mov ax, 0xb800
    mov es, ax

    mov di, 1990

    mov cx, 10

Print_start:
    mov dl, [si]
    mov dh, 0x0A
    mov [es:di], dx
    add di, 2
    inc si
    loop Print_start

    pop dx
    pop cx
    pop di
    pop si
    mov sp, bp
    pop bp
    ret 2
	 
Over_Screen:
    push bp
    mov bp, sp
    push si
    push di
    push cx
    push dx

    mov si, endtext

    mov ax, 0xb800
    mov es, ax

    mov di, 1990

    mov cx, 9

Print_over:
    mov dl, [si]
    mov dh, 0x0A
    mov [es:di], dx
    add di, 2
    inc si
    loop Print_over

    pop dx
    pop cx
    pop di
    pop si
    mov sp, bp
    pop bp
    ret 2	 

player_x: dw 40
bullet_x: dw 0
bullet_y: dw 0
bulletActive: db 0
ScoreText: db 'Score: '
score: dw 0

starttext: db 'Game Start'
endtext: db 'Game Over' 

old_offset: dw 0
old_segment: dw 0
tick_count: dw 0
game_over: db 0