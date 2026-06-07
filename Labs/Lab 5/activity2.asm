[org 0x0100]

jmp start

arr1:   dw 2,5,9
arr2:   dw 1,4,7,8
merged: dw 0,0,0,0,0,0,0  

c1: dw 3        
c2: dw 4        
c3: dw 7       

MergeArrays:
    push bp
    mov  bp, sp

    mov  si, [bp+12]   
    mov  di, [bp+10]    
    mov  bx, [bp+8]     
    mov  cx, [bp+6]    
    mov  dx, [bp+4]    

merge_loop:
    cmp cx,0
    je  copy_arr2       ; copy arr2
    cmp dx,0
    je  copy_arr1       ; copy arr1

    mov ax,[si]         ; arr1
    mov bp,[di]         ; arr2
    cmp ax,bp
    jle take_arr1       

    mov [bx],bp
    add di,2
    add bx,2
    dec dx
    jmp merge_loop

take_arr1:
    mov [bx],ax
    add si,2
    add bx,2
    dec cx
    jmp merge_loop

copy_arr1:
    cmp cx,0
    je done
copy1_loop:
    mov ax,[si]
    mov [bx],ax
    add si,2
    add bx,2
    dec cx
    jnz copy1_loop
    jmp done

copy_arr2:
    cmp dx,0
    je done
copy2_loop:
    mov ax,[di]
    mov [bx],ax
    add di,2
    add bx,2
    dec dx
    jnz copy2_loop
    jmp done

done:
    pop bp
    ret 10       

start:

    push word [c2]      
    push word [c1]      
    mov ax, merged
    push ax             
    mov ax, arr2
    push ax             
    mov ax, arr1
    push ax             

    call MergeArrays

    mov ax,0x4c00
    int 0x21
