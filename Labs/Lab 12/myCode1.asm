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
    
    cmp byte [getPositiony], 1
    je exit_game

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
    
    call clearPlayer
    dec word [player_x]
    call draw_player
    jmp update_bullet

move_right:
    cmp word [player_x], 79
    jge update_bullet
    
    call clearPlayer
    inc word [player_x]
    call draw_player
    jmp update_bullet

fire_bullet:
    cmp byte [bulletActive], 1
    je update_bullet
    
    mov ax, [player_x]
    mov [bullet_x], ax
    mov word [bullet_y], 23
    mov byte [bulletActive], 1
    
    call drawBullet
    jmp update_bullet

update_bullet:
    cmp byte [bulletActive], 1
    jne main
    
    call drawBullet
    
    dec word [bullet_y]
    cmp word [bullet_y], 0
    jl deleteBullet
    
    call getPositiony
    
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
    push ds
    push es
    
    push cs
    pop ds                  
    
    mov ax, 0B800h         
    mov es, ax

    inc word [tick_count]
    cmp word [tick_count], 18  
    jl end           
    
    mov word [tick_count], 0
    
    call move_bubbles_down

end:

    pop es
    pop ds
    pop bx
    pop ax
    
    jmp far [cs:old_offset] 

move_bubbles_down:
    
    mov di, 3838            

check:
    cmp di, 0
    jl finish_move          

    mov al, byte [es:di]
    cmp al, 'O'
    jne next_cell

    mov bx, di
    add bx, 160             
    
    cmp bx, 3840
    jae gameover
    
    mov byte [es:bx], 'O'   
    mov byte [es:bx+1], 03h 

    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    
next_cell:
    sub di, 2               
    jmp check

gameover:
    mov byte [getPositiony], 1
    jmp finish_move

finish_move:
    ret

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
    call getPositionx
    mov byte [es:di], 254
    mov byte [es:di+1], 0Eh
    ret

clearPlayer:
    call getPositionx
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    ret

drawBullet:
    call getPositiony
    mov byte [es:di], 24h
    mov byte [es:di+1], 0Ch
    ret

eraseBullet:
    call getPositiony
    mov byte [es:di], ' '
    mov byte [es:di+1], 07h
    ret

getPositionx:
    mov ax, 24
    mov bx, 80
    mul bx
    add ax, [player_x]
    shl ax, 1
    mov di, ax
    ret

getPositiony:
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
    
    mov cx,7        
    
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
bulletActive: db 0
ScoreText: db 'Score: '
score: dw 0

old_offset: dw 0
old_segment: dw 0
tick_count: dw 0
getPositiony: db 0