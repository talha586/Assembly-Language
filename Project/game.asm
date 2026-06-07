;;24L-0618 && 24L0514

[org 0x0100]

jmp start

Name: db 'TAPING SHAPES'
Instruction1: db 'Following are the instructions:'
Instruction2: db '1) Click the letter on the keyboard to destroy the specific shape.'
Instruction3: db '2) After every 1 destructions of shapes, you will get 1 score.'
Instruction4: db '3) After every 30 seconds your level will increase by 1.'
Instruction5: db '4) Best of luck for the Game.'
PressEnterMsg: db 'Press Enter to continue...'

PrintLoad: db 'Loading...'

tickCount: dw 0
second: dw 0
rand_val: dw 1234                                   ; random value

array1: db 'Time: '
array2: db 'Score: '
array3: db 'TAPING SHAPES'

array4: db 'Time:'
array5: db 'Score:'
array6: db 'Level:'
endDisplay : db 'THE END'

oldisr_tmer : dd 0

alphabet : db 'abcdefghijklmnopqrstuvwxyz'
cuur_alphabet : db ' '
counter : dw 0

ballon_x: dw 0                                               
ballon_y: dw 21                                              

position: dw 10, 70, 20, 60, 30, 50, 40, 15, 65, 35          
curr_position: dw 0                                          

ballon2_x: dw 0
ballon2_y: dw 21
cuur_alphabet2: db ' '
curr_position2: dw 4     
level2_flag: db 0                                            

GameScore: dw 0

line1 db '        *     * *****   BBBB   AAAA  L     L      OOO   OOO  N   N  SSSS',0
line2 db '        **   **   *     B   B A    A L     L     O   O O   O NN  N S',0
line3 db '        * * * *   *     BBBB  AAAAAA L     L     O   O O   O N M N  SSS',0
line4 db '        *  *  *   *     B   B A    A L     L     O   O O   O N  NN     S',0
line5 db '        *     *   *     BBBB  A    A LLLLL LLLLL  OOO   OOO  N   N SSSS',0

bal_1 db '   ***   ',0
bal_2 db '  *   *  ',0
bal_3 db '  *   *  ',0
bal_4 db '   ***   ',0
bal_5 db '    |    ',0

line6 db '                GGGG   AAAA  M   M EEEE    OOO  V   V EEEE RRRR ',0
line7 db '               G      A    A MM MM E      O   O V   V E    R   R',0
line8 db '               G  GG  AAAAAA M M M EEEE   O   O V   V EEEE RRRR ',0
line9 db '               G   G  A    A M   M E      O   O  V V  E    R R  ',0
line10 db '                GGGG  A    A M   M EEEE    OOO    V   EEEE R  RR',0

bal_6 db '  * \ | / *  ',0
bal_7 db '   *  *  *   ',0
bal_8 db '  *  ***  *  ',0
bal_9 db '   *  |  *   ',0
bal_10 db '      |      ',0

PlayIntroSound:
    push ax
    push bx
    push cx
    push dx

    mov bx, 4560          ;Gives the Pitch
    call SoundOn
    mov cx, 4            ;Gives Time Period
    call SoundDelay
    
    mov bx, 3619
    call SoundOn
    mov cx, 4
    call SoundDelay

    mov bx, 3043
    call SoundOn
    mov cx, 8       
    call SoundDelay

    call SoundOff
    pop dx
    pop cx
    pop bx
    pop ax
    ret

PlayPopSound:
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 2000     
pop_sweep:
    call SoundOn
    
    mov cx, 500      
pop_delay:
    loop pop_delay
    
    add bx, 200      
    cmp bx, 4000
    jl pop_sweep
    
    call SoundOff
    pop dx
    pop cx
    pop bx
    pop ax
    ret

PlayGameOverSound:
    push ax
    push bx
    push cx
    push dx
    
    mov bx, 1000    
go_sweep_loop:
    call SoundOn
    
    mov cx, 2000    
go_inner_delay:
    loop go_inner_delay
    
    add bx, 50     
    cmp bx, 8000     
    jl go_sweep_loop
    
    call SoundOff
    pop dx
    pop cx
    pop bx
    pop ax
    ret

SoundOn:
    push ax
    mov al, 10110110b                 ;using port 43h we ready the computer that values will be sent to produce sound
    out 43h, al                       ;sending the actual pitch number as stored in BX resgister
    mov ax, bx                        ;Since the bx is 16 bit and 42h is 8 bit register we separately pass the pitches
    out 42h, al       
    mov al, ah
    out 42h, al                      
    in al, 61h                         ;take value from 61h
    or al, 00000011b                  ;takes or with 3 to make the
    out 61h, al                       ;writes on 61h by switching on the last two bits so that sound is produced
    pop ax
    ret

SoundOff:
    push ax
    in al, 61h
    and al, 11111100b 
    out 61h, al
    pop ax
    ret

SoundDelay:
    push cx
    push dx
sd_outer:
    mov dx, 0FFFFh   
sd_inner:
    dec dx
    jnz sd_inner
    loop sd_outer
    pop dx
    pop cx
    ret

;GAME STARTING SCREEN

move_cursor:               ;Takes row from DH and Col from Dl
    mov ah, 02h            ;For Setting Cursor Position on the screen
   ; mov bh, 00h            ;for setting page number 0 on the screen as it is the default page
    int 10h                ;Used for Video services and it reads the Ah,Dh ,Dl and Bh and sends values to video memory
    ret

print_string:
    push ax
    push cx
    push dx
    push si
    
next_char:
    lodsb                  ;loads byte from SI to AL
    cmp al,0               
    je done_print

    mov ah, 03h             ;Get Cursor Positions
    mov bh, 00h
    int 10h

    mov ah, 09h             ;Writing Character at the cursor position     
    mov cx, 1               ;For Counter
    int 10h

    inc dl                  ;Movig Cursor as DH contains row and Dl contains Colo
    mov ah, 02h             ;move the blinking cursor to next position
    int 10h 

    call delay              ; Small Delay for Typing Effect
    
    jmp next_char

done_print:
    pop si
    pop dx
    pop cx
    pop ax
    ret

newline:                     ;moves cursor to next position 
    mov ah,0Eh               ;used for teletype purpose like print and move the cursor forward and move right
    mov al,13
    int 10h
    mov al,10                ;used for teletype purpose like print and move the cursor forward and movem down
    int 10h
    ret

delay:                        
    push cx
    push dx
    mov cx, 500      
delay_outer:
    mov dx, 100      
delay_inner:
    dec dx
    jnz delay_inner
    loop delay_outer
    pop dx
    pop cx
    ret

draw_balloons:                ; For Drawing Ballons on the Screen
    mov dh, 0                 ;moving rows and Cols
    mov dl, 0
    call draw_single_balloon
	
    mov dh, 0
    mov dl, 70
    call draw_single_balloon

    mov dh, 20
    mov dl, 0
    call draw_single_balloon

    mov dh, 20
    mov dl, 70
    call draw_single_balloon
    ret

draw_single_balloon:
    push dx        
    
    call move_cursor                   
    mov si, bal_1
    call print_string
    
    pop dx           
    inc dh                               ;dh holds row and dl holds column
    push dx          
    call move_cursor
    mov si, bal_2
    call print_string

    pop dx;
    inc dh
    push dx
    call move_cursor
    mov si, bal_3
    call print_string

    pop dx
    inc dh
    push dx
    call move_cursor
    mov si, bal_4
    call print_string

    pop dx
    inc dh
    call move_cursor 
    mov si, bal_5
    call print_string
ret

;;GAME OVER SCREEN

draw_text_block:
    mov dh, 10
    mov dl, 00
    call move_cursor

    mov si, line6
    call print_string_instant
    call newline

    mov si, line7
    call print_string_instant
    call newline

    mov si, line8
    call print_string_instant
    call newline

    mov si, line9
    call print_string_instant
    call newline

    mov si, line10
    call print_string_instant
    call newline
    ret

print_string_instant:
    push ax
    push cx
    push dx
    push si
    
next_char_inst:
    lodsb
    cmp al,0
    je done_print_inst

    ; Get Cursor
    mov ah, 03h
    mov bh, 00h
    int 10h

    ; Write Char
    mov ah, 09h
    mov cx, 1
    int 10h

    ; Advance Cursor
    inc dl
    mov ah, 02h
    int 10h
    
    jmp next_char_inst

done_print_inst:
    pop si
    pop dx
    pop cx
    pop ax
    ret
	
newline2:
    mov ah, 03h      
    mov bh, 00h
    int 10h
    
    inc dh          
    mov dl, 00      
    
    mov ah, 02h      
    int 10h
    ret	

delay_blink:
    push cx
    push dx
    mov cx, 0       
blink_outer:
    mov dx, 20      
blink_inner:
    dec dx
    jnz blink_inner
    loop blink_outer
    pop dx
    pop cx
    ret	
	
draw_balloons2:
    mov dh, 0
    mov dl, 0
    call draw_single_balloon2

    mov dh, 0
    mov dl, 67
    call draw_single_balloon2

    mov dh, 20
    mov dl, 0
    call draw_single_balloon2

    mov dh, 20
    mov dl, 67
    call draw_single_balloon2
    ret
	
draw_single_balloon2:
    push dx         
    
    call move_cursor 
    mov si, bal_6
    call print_string
    
    pop dx           
    inc dh          
    push dx          
    call move_cursor
    mov si, bal_7
    call print_string

    pop dx 
    inc dh
    push dx
    call move_cursor
    mov si, bal_8
    call print_string

    pop dx
    inc dh
    push dx
    call move_cursor
    mov si, bal_9
    call print_string

    pop dx
    inc dh
    call move_cursor 
    mov si, bal_10
    call print_string
    ret

;FOR CLEAR SCREEN
ClrScr:
    push es
    push ax
    push di
    mov ax,0xb800
    mov es,ax
    mov di,0

nextLoc: 
    mov word [es:di],0x0720
    add di,2
    cmp di,4000
    jne nextLoc
    
    pop di
    pop ax
    pop es 
    ret

;PRINT STARTING SCREEN & INSTRUCTIONS
PrintName2:
     push bp
     mov bp,sp
     push si
     push di
     push ax
    
     mov si,[bp+4]
    
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,4
     mul dl
     add ax,30
     shl ax,1
     mov di,ax
    
     mov cx,13
Print2:     
     mov dl,[si]
     mov dh,0x0C
     mov [es:di],dx
     add di,2
     add si,1
     loop Print2
    
     pop ax
     pop di
     pop si
     mov sp,bp
     pop bp
     
     ret 2
     
PrintInstruct:
     push bp
     mov bp,sp
     push si
     
     mov si,[bp+4]
     
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,8
     mul dl
     add ax,22
     shl ax,1
     mov di,ax
     mov cx, 31
     
PrintInstruct1: 
    
     mov dl,[si]
     mov dh,0x07
     mov [es:di],dx
     add di,2
     add si,1
     loop PrintInstruct1     
     
     mov si,[bp+6]
     
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,9
     mul dl
     add ax,7
     shl ax,1
     mov di,ax
     mov cx, 66
     
PrintInstruct2: 
    
     mov dl,[si]
     mov dh,0x07
     mov [es:di],dx
     add di,2
     add si,1
     loop PrintInstruct2    

     mov si,[bp+8]
     
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,10
     mul dl
     add ax,7
     shl ax,1
     mov di,ax
     mov cx, 62
     
PrintInstruct3: 
    
     mov dl,[si]
     mov dh,0x07
     mov [es:di],dx
     add di,2
     add si,1
     loop PrintInstruct3    

     mov si,[bp+10]
     
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,11
     mul dl
     add ax,8
     shl ax,1
     mov di,ax
     mov cx, 56
     
PrintInstruct4: 
    
     mov dl,[si]
     mov dh,0x07
     mov [es:di],dx
     add di,2
     add si,1
     loop PrintInstruct4    

     mov si,[bp+12]
     
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,12
     mul dl
     add ax,22
     shl ax,1
     mov di,ax
     mov cx, 29
     
PrintInstruct5: 
    
     mov dl,[si]
     mov dh,0x07
     mov [es:di],dx
     add di,2
     add si,1
     loop PrintInstruct5         
     
     mov si,[bp+14]
     
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,16
     mul dl
     add ax,24
     shl ax,1
     mov di,ax
     mov cx, 26
     
PrintInstruct6: 
    
     mov dl,[si]
     mov dh,0x8C
     mov [es:di],dx
     add di,2
     add si,1
     loop PrintInstruct6     
     
     pop si
     mov sp, bp
     pop bp
     
     ret 12
     
     
PrintPattern:
    push bp
    mov bp,sp
    push cx
    push es
    push di
    push ax
    
    mov ax,0xb800
    mov es,ax
    
    mov ah,0
    mov al,80
    mov dh,0
    mov dl,2
    mul dl
    add ax,5
    shl ax,1
    mov di,ax
    
    mov cx,68
    
PrintDesUp: 
    mov word [es:di],0x0B2A
    add di,2
    loop PrintDesUp
    
    mov cx,16

PrintDesRight:  
    mov word [es:di],0x0B2A
    add di,160
    loop PrintDesRight

    mov cx,68
    
PrintDesDown:   
    mov word [es:di],0x0B2A
    sub di,2
    loop PrintDesDown   
    
    mov cx,16

PrintDesLeft:   
    mov word [es:di],0x0B2A
    sub di,160
    loop PrintDesLeft
    
    add di,640
    mov cx,68
    
PrintDesUp1:    
    mov word [es:di],0x0B2A
    add di,2
    loop PrintDesUp1
    
    add di,1144
    mov cx,68
    
PrintDesUp2:    
    mov word [es:di],0x0B2A
    add di,2
    loop PrintDesUp2
    
    pop ax
    pop di
    pop es
    pop cx
    mov sp,bp
    pop bp
    
ret

PrintName:
     push bp
     mov bp,sp
     push si
     push di
     push ax
    
     mov si,[bp+4]
    
     mov ax,0xb800
     mov es,ax
     mov al,80
     mov dl,0
     mul dl
     add ax,30
     shl ax,1
     mov di,ax
    
     mov cx,13

Print:      
     mov dl,[si]
     mov dh,0x30
     mov [es:di],dx
     add di,2
     add si,1
     loop Print
    
     pop ax
     pop di
     pop si
     mov sp,bp
     pop bp
     
     ret 2

;PRINtiNG TIME AND SCORE

PrintTimeAndScore:
    push bp
    mov bp,sp
    push si
    push bx
    push di
    push ax
    
    mov si,[bp+4]
    mov bx,[bp+6]
    
    mov ax,0xb800
    mov es,ax
    
    mov ah,0
    mov al,80
    mov dh,0
    mov dl,1
    mul dl
    add ax,24
    shl ax,1
    mov di,ax
    
    mov cx,6
    
PrintScore: 
    mov dl,[si]
    mov dh,0x30
    mov [es:di],dx
    add di,2
    add si,1
    loop PrintScore
    
    mov cx,7
    add di,12
    
PrintTime:  
    mov dl,[bx]
    mov dh,0x30
    mov [es:di],dx
    add di,2
    add bx,1
    loop PrintTime  
    
    pop ax
    pop di
    pop bx
    pop si
    mov sp,bp
    pop bp
    
    ret 4

;DRAW BACKGROUND
    
PrintBack:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push di

    mov ax, 0xb800
    mov es, ax
    xor di, di   
    mov ax, 0x3020     
    mov cx, 1760        
draw_sky:
    mov word [es:di], ax
    add di, 2
    loop draw_sky
	
    mov ax, 0x2020      
    mov cx, 240   
    
draw_grass:
    mov word [es:di], ax
    add di, 2
    loop draw_grass

;DRAW STARS

draw_stars: 
    
    mov di, 152       
    mov word [es:di], 0x3E0F 
	
	mov di, 112      
    mov word [es:di], 0x3E0F 
	
	mov di, 200      
    mov word [es:di], 0x3E0F 
    
	mov di, 250      
    mov word [es:di], 0x3E0F 
	
	mov di, 270      
    mov word [es:di], 0x3E0F 
	
	mov di, 280     
    mov word [es:di], 0x3E0F 
	
    mov di, 180      
    mov word [es:di], 0x3E0F  
    
    mov di, 172   
    mov word [es:di], 0x3E0F 
	
    mov di, 92      
    mov word [es:di], 0x3E0F 
    
    
    pop di
    pop cx
    pop ax
    pop es
    pop bp
ret 

;BALLONS LOGIC
    
PrintBallons:
    push bp
    mov bp,sp
    push es
    push ax
    push di
    push bx
    
    mov ax,0xb800
    mov es,ax
    mov ax,[bp+6]
    mov bx ,80
    mul bx
    add ax,[bp+8]
    shl ax,1
    mov di,ax
    
    mov word [es:di],0x3020
    mov word [es:di+2],0x4F2A
    mov word [es:di+4],0x3020
    add di,160
    mov word[es:di],0x4F2A
    mov al,[bp+4]
    mov ah,0x4F
    mov [es:di+2],ax
    mov word [es:di+4],0x4F2A
    add di,160
    mov word [es:di], 0x3020   
    mov word [es:di+2], 0x4F2A 
    mov word [es:di+4], 0x3020 
    add di, 160
    mov word [es:di], 0x3020   
    mov word [es:di+2], 0x307C
    mov word [es:di+4], 0x3020 

    pop bx
    pop di
    pop ax
    pop es
    pop bp
    ret 6   

;Generating Random Numbers
GetRandomNum:
    push ax
    push cx
    push dx
    
    
    mov ax, [rand_val]
    add ax, [tickCount] 
    
    ; Linear Congruential Generator Math
    mov cx, 37          ; Prime multiplier
    mul cx
    add ax, 17          ; Prime increment
    mov [rand_val], ax ; Store new seed
    
    xor dx, dx
    mov cx, 26          ; Taking Mod with 26 so remainder remains between 0-25
    div cx              
    
    mov bx, dx          
    
    pop dx
    pop cx
    pop ax
    ret

SetBallon:                          
    push ax
    push bx
    push si
    
    mov word [ballon_y],19          
    
	;For Getting X postion from Array
    mov bx,[curr_position]
    mov ax,[position+bx]
    mov [ballon_x],ax
    
 	;Comparing if greater than 20(size of position array) then start from start
    add bx,2
    cmp bx,20
    jl update_curent_pos
    mov bx,0

update_curent_pos:                  
    mov [curr_position],bx

    call GetRandomNum       
    mov si, alphabet
    mov al, [si+bx]                ;adding random value to get random numbers
    mov [cuur_alphabet],al

    pop si
    pop bx
    pop ax
    
ret  

SetBallon2:
    push ax
    push bx
    push si
    
    mov word [ballon2_y],19
    
    mov bx,[curr_position2]
    mov ax,[position+bx]
    mov [ballon2_x],ax
    
    add bx,2
    cmp bx,20
    jl update_curent_pos2
    mov bx,0

update_curent_pos2:
    mov [curr_position2],bx

    call GetRandomNum       ; Returns random 0-25 in BX
    mov si, alphabet
    mov al, [si+bx]
    mov [cuur_alphabet2],al

    pop si
    pop bx
    pop ax
    ret   
    
EraseBallon:                         ;Clearing of Ballons
    push bp
    mov bp,sp
    push es
    push ax
    push di
    push bx
    
    mov ax,0xb800
    mov es,ax
    
    mov ax,[bp+4]                     ;Y_Coordinate
    mov bx,80
    mul bx
    add ax,[bp+6]                     ;X-Coordinate
    shl ax,1
    
    mov di,ax
    mov word [es:di],0x3020
    mov word [es:di+2],0x3020
    mov word [es:di+4],0x3020
    add di,160
    mov word[es:di],0x3020
    mov word [es:di+2], 0x3020
    mov word [es:di+4],0x3020
    add di,160
    mov word [es:di], 0x3020   
    mov word [es:di+2], 0x3020
    mov word [es:di+4], 0x3020 
    add di, 160
    mov word [es:di], 0x3020   
    mov word [es:di+2], 0x3020
    mov word [es:di+4], 0x3020 
    
    pop bx
    pop di
    pop ax
    pop es
    mov sp,bp
    pop bp
    
    ret 4
        
UpdateScore:                        ;Converts Score to String and then print on the screen 
    push bp
    mov bp,sp
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    
    mov ax,0xb800
    mov es,ax

    mov ax,[bp+4]                   ;Receive Score Values
    mov bx,10
    mov cx,0
    
nextDigitScore:                     ;Dividde by 10 to get the digit
    mov dx,0
    div bx
    add dl,0x30                     ;Converting to ascii
    push dx
    inc cx
    cmp ax,0
    jnz nextDigitScore
    
    mov di, 246                     ;Printing on Screen Location
    
ScoreLoop:
    pop dx
    mov dh,0x30
    mov [es:di],dx
    add di,2        
    loop ScoreLoop
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    mov sp,bp
    pop bp
    ret 2

PrintLoading:
    push bp
    mov bp, sp
    push si
    push es
    push di
    push ax
    push cx
    push bx
    push dx
    
    mov si, [bp+4]
    
    mov ax, 0xb800
    mov es, ax
    
    mov ax, 160         
    mov bx, 12         
    mul bx
    add ax, 70          
    mov di, ax
    
    mov cx, 10          

DisplayLoadText:
    lodsb               
    mov ah, 0x87        
    stosw               
    loop DisplayLoadText
    
    mov ax, 160        
    mov bx, 14          
    mul bx
    add ax, 70          
    mov di, ax
    
    mov cx, 8          

NextLoadingBox:                      ;Creating the Load Color with delay
    mov word [es:di], 0x4020
    
    push cx             
    
    mov cx, 0xFFFF    
DelayOuter:
    mov dx, 0x0015      
DelayInner:
    dec dx
    jnz DelayInner
    loop DelayOuter
    
    pop cx              
    
    add di, 2           
    loop NextLoadingBox 
    
    pop dx
    pop bx
    pop cx
    pop ax
    pop di
    pop es
    pop si
    mov sp, bp
    pop bp
    
    ret 2    

;ENDING SCREENS

PrintWordNum:                       ;Helper Function to Print Numbers on the screen
    push ax
    push bx
    push cx
    push dx
    push di 
    
    mov bx, 10
    mov cx, 0
calc_loop:
    mov dx, 0
    div bx
    add dl, '0'
    push dx
    inc cx
    test ax, ax
    jnz calc_loop
    
print_loop:
    pop dx
    mov dh, 0x07 
    mov [es:di], dx
    add di, 2
    loop print_loop
    
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    ret	
	
PrintTimeAndScore_end:
    push bp
    mov bp,sp
    push si
    push bx
    push di
    push ax
    
    mov si,[bp+4]
    mov bx,[bp+6]
    
    mov ax,0xb800
    mov es,ax
    
    mov ah,0
    mov al,80
    mov dh,0
    mov dl,9
    mul dl
    add ax,35
    shl ax,1
    mov di,ax
    
    mov cx,5
    
PrintTime_end: 
    mov dl,[si]
    mov dh,0x07
    mov [es:di],dx
    add di,2
    add si,1
    loop PrintTime_end
    
	add di,2
	mov ax,[second]
	call PrintWordNum
	
    mov cx,6
    add di,308
    
PrintScore_end:  
    mov dl,[bx]
    mov dh,0x07
    mov [es:di],dx
    add di,2
    add bx,1
    loop PrintScore_end
	
	add di,2
    mov ax,[GameScore]
    call PrintWordNum
    
done:
    pop ax
    pop di
    pop bx
    pop si
    mov sp,bp
    pop bp
    
    ret 6

DisplayEndGame_end:
    push bp
    mov bp,sp
    push cx
    push si
    push es
    push di
    push ax
    
    mov si,[bp+4]
    
    mov ax,0xb800
    mov es,ax
    
    mov ah,0
    mov al,80
    mov dh,0
    mov dl,5
    mul dl
    add ax,36
    shl ax,1
    mov di,ax
    
    mov cx,7
PrintEnd_end:   
    mov dl,[si]
    mov dh,0x8C
    mov [es:di],dx
    add di,2
    add si,1
    loop PrintEnd_end   
    
    pop ax
    pop di
    pop es
    pop si
    pop cx
    mov sp,bp
    pop bp
    
ret 2

PrintPattern_end:
    push bp
    mov bp,sp
    push cx
    push es
    push di
    push ax
    
    mov ax,0xb800
    mov es,ax
    
    mov ah,0
    mov al,80
    mov dh,0
    mov dl,3
    mul dl
    add ax,24
    shl ax,1
    mov di,ax
    
    mov cx,30
    
PrintDesUp_end: 
    mov word [es:di],0x0B2A
    add di,2
    loop PrintDesUp_end
    
    mov cx,12

PrintDesLeft_end:   
    mov word [es:di],0x0B2A
    add di,160
    loop PrintDesLeft_end

    mov cx,30
    
PrintDesDown_end:   
    mov word [es:di],0x0B2A
    sub di,2
    loop PrintDesDown_end   
    
    mov cx,12

PrintDesRight_end:  
    mov word [es:di],0x0B2A
    sub di,160
    loop PrintDesRight_end
    
    add di,640
    mov cx,30
    
PrintDesUp1_end:    
    mov word [es:di],0x0B2A
    add di,2
    loop PrintDesUp1_end
    
    pop ax
    pop di
    pop es
    pop cx
    mov sp,bp
    pop bp
    
ret
    
PrintNum:                         ;For Number Updating With Time
    push bp
    mov bp,sp
    push es
    push di
    push ax
    push bx
    push cx
    push dx
    
    mov ax,0xb800
    mov es,ax

    mov ax,[bp+4]
    mov bx,10
    mov cx,0
    
nextDigit:
    mov dx,0
    div bx
    add dl,0x30
    push dx
    inc cx
    cmp ax,0
    jnz nextDigit
    
    mov di, 218
    
nextpos:
    pop dx
    mov dh,0x30
    mov [es:di],dx
    add di,2        
    loop nextpos
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    pop es
    mov sp,bp
    pop bp
ret 2   
    
;HOOKING TIMER  
    
timer:
    push ax
    
    inc word [cs:tickCount]             ;Incrementing the ticks
    cmp word[cs:tickCount],18           ;Since 18 ticks = 1 seconds 
    jne timer_exit
    
    mov word[cs:tickCount],0           ;Reset Ticks
    inc word[cs:second]                ;Incrementing Seconds
    
    push word[cs:second]
    call PrintNum                      ;Updating on the screen
    
timer_exit:
    mov al,0x20
    out 0x20,al
    
    pop ax  
iret    

start:
    ;Displaying the Starting Screen
    call ClrScr
	
	mov bl, 0Bh      
    call draw_balloons

    mov dh, 10      
    mov dl, 00       
    call move_cursor 

    mov bl, 07h      

    mov si,line1
    call print_string
    call newline

    mov si,line2
    call print_string
    call newline

    mov si,line3
    call print_string
    call newline

    mov si,line4
    call print_string
    call newline

    mov si,line5
    call print_string
    call newline
	
	call ClrScr
	
continue:
    ;Display of Instructions
    mov ax, Name
    push ax
    call PrintName2

    mov ax, PressEnterMsg
    push ax
    mov ax, Instruction5
    push ax
    mov ax, Instruction4
    push ax
    mov ax, Instruction3
    push ax
    mov ax, Instruction2
    push ax
    mov ax, Instruction1
    push ax

    call PrintInstruct
    call PrintPattern
  
    ;Wait For Enter Key to Continue

mov ah,0
int 16h

   cmp ah,0x1C
   jne continue
    
   call ClrScr
   
   ;Loading Scren
   
    mov ax,PrintLoad
	push ax
	call PrintLoading

   call ClrScr   

   ;Game BackGround Printing

   call PrintBack
   
   call PlayIntroSound
   
   mov ax,array3
   push ax
   call PrintName 
   mov ax,array2
   push ax
   mov ax, array1
   push ax
   
   call PrintTimeAndScore
   call SetBallon
   
   mov ax,[ballon_x]
   push ax
   mov ax,[ballon_y]
   push ax
   mov ax,[cuur_alphabet]
   push ax
   call PrintBallons
   
   xor ax,ax
   mov es,ax
   
   ;Hooking Timer Interupt
   
   mov ax,[es:8*4]
   mov [oldisr_tmer],ax
   mov ax,[es:8*4+2]
   mov [oldisr_tmer+2],ax
   
   ;Setting New Interupts
   
   cli                         ; Disaling interupts while changing IVT
   mov word [es:8*4],timer
   mov word [es:8*4+2],cs
   sti                         ;Re-Enable Interrupts
   
game_loop:
    cmp word [cs:second], 60
    jge game_over_jmp

    cmp word [cs:second], 30
    jl check_key
    
    cmp byte [cs:level2_flag], 0
    jne check_key
    
    mov byte [cs:level2_flag], 1
    call SetBallon2
    
check_key:                                       
    mov ah,01h
    int 16h
    jz no_key_press
    
    mov ah,00h
    int 16h
    
    cmp al,[cuur_alphabet]
    jne check_balloon_2
    

    call PlayPopSound
    
    mov ax,[ballon_x]
    push ax
    mov ax,[ballon_y]
    push ax
    call EraseBallon
    
    inc word[GameScore]
    push word [GameScore]
    call UpdateScore
    
    call SetBallon
    
    mov ax, [ballon_x]
    push ax
    mov ax, [ballon_y]
    push ax
    mov al, [cuur_alphabet]
    xor ah,ah
    push ax
    call PrintBallons
    jmp no_key_press

check_balloon_2:
    cmp byte [cs:level2_flag], 1
    jne no_key_press
    
    cmp al, [cuur_alphabet2]
    jne no_key_press
    
    call PlayPopSound
    
    mov ax,[ballon2_x]
    push ax
    mov ax,[ballon2_y]
    push ax
    call EraseBallon
    
    inc word[GameScore]
    push word [GameScore]
    call UpdateScore
    
    call SetBallon2
    
    mov ax, [ballon2_x]
    push ax
    mov ax, [ballon2_y]
    push ax
    mov al, [cuur_alphabet2]
    xor ah,ah
    push ax
    call PrintBallons

no_key_press:
    mov ax,[tickCount]
    cmp ax,[counter]                  ;only move if ticks changed
    je game_loop
    
    mov [counter],ax                   
    test ax,0x03                       ;Slowing Down Movement (only move after every 4 tick)
    jnz game_loop

    ;Erase Ballon at Current Position
    mov ax,[ballon_x]
    push ax
    mov ax,[ballon_y]
    push ax
    call EraseBallon
    
    cmp byte [cs:level2_flag], 1
    jne update_pos
    
    mov ax,[ballon2_x]
    push ax
    mov ax,[ballon2_y]
    push ax
    call EraseBallon

update_pos:
    dec word[ballon_y]
    cmp word [ballon_y],2               ;Checking if hit top of screen

    jge check_pos2
	
	cmp word [GameScore],0
	je skip
	
	dec word[GameScore]                 ; if hit top then decrement score by 1
	push word [GameScore]
	call UpdateScore

skip:	
    call SetBallon

check_pos2:
    cmp byte [cs:level2_flag], 1
    jne draw_new
    
    dec word[ballon2_y]
    cmp word [ballon2_y], 2
    jge draw_new
	
	cmp word [GameScore],0
	je skip2
	
    dec word[GameScore]
	push word [GameScore]
	call UpdateScore

skip2:	
	
    call SetBallon2

draw_new:                                 ;Drawing Ballon at new Position
    mov ax, [ballon_x]
    push ax
    mov ax, [ballon_y]
    push ax
    mov al, [cuur_alphabet]
    xor ah, ah
    push ax
    call PrintBallons

    cmp byte [cs:level2_flag], 1
    jne continue_loop
    
    mov ax, [ballon2_x]
    push ax
    mov ax, [ballon2_y]
    push ax
    mov al, [cuur_alphabet2]
    xor ah, ah
    push ax
    call PrintBallons

continue_loop:
    jmp game_loop

game_over_jmp:
    jmp game_over
	
game_over:
    ;Restore the TImer Interrupt for the remaining stable functionality
	cli
    xor ax,ax
    mov es,ax
    mov ax,[oldisr_tmer]
    mov [es:8*4],ax
    mov ax,[oldisr_tmer+2]
    mov [es:8*4+2],ax
    sti

    ;Printing the GameOver screen
    call ClrScr
    mov bl, 0Ch      
    call draw_balloons2
    mov dh, 10
    mov dl, 00
    call move_cursor
    mov bl, 0Ch
    mov si, line6
    call print_string
    call newline
    mov si, line7
    call print_string
    call newline
    mov si, line8
    call print_string
    call newline
    mov si, line9
    call print_string
    call newline
    mov si, line10
    call print_string
    call newline

blink_loop:
    mov ah, 01h                                ;check whteher press enter skip to end screen
    int 16h
    jnz end_screen                             
    call delay_blink                           ;for creating some delay
    mov bl, 00h                                ;for creating the text to black so that it blinks properly
    call draw_text_block                        
    mov ah, 01h
    int 16h
    jnz end_screen
    call delay_blink
    mov bl, 0Ch                                ;for again creating the color
    call draw_text_block
    jmp blink_loop

end_screen:
    
    call ClrScr
    call PlayGameOverSound
    
    mov ax,endDisplay
    push ax
    call DisplayEndGame_end
    
    mov ax,array6
    push ax
    mov ax,array5
    push ax
    mov ax, array4
    push ax
   
    call PrintTimeAndScore_end
    call PrintPattern_end
  
mov ax,0x4c00
int 0x21