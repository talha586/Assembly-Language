[org 0x0100]

jmp start

array1: dw 1,3,5,7
array2: dw 1,2,3,4
array3: dw 1,3,5,7,9

size1: dw 4
size2: dw 4
size3: dw 5

key1: dw 5
key2: dw 2
key3: dw 9

result: dw 0

BinarySearch:
    push bp
    mov bp, sp
    push bx
    push cx
    push dx
    push si

    mov si, [bp+8]
    mov cx, [bp+6]
    mov bx, [bp+4]

    mov dx, 0
    mov ax, cx
    dec ax

loop1:
    cmp dx, ax
    jg not_found

    mov cx, dx
    add cx, ax
    mov ah, 0
    mov al, cl
    mov bl, 2
    div bl
    mov si, [bp+8]
    mov bx, ax
    shl bx, 1
    add si, bx
    mov bx, [si]

    mov di, [bp+4]
    mov di, [di]
    cmp di, bx
    je found
    jb right

    mov bl, al
    inc bl
    mov dl, bl
    jmp loop1

right:
    mov bl, al
    dec bl
    mov ah, 0
    mov al, bl
    mov ax, bx
    jmp binary_loop

found:
    mov ax, 1
    jmp done

not_found:
    mov ax, 0

done:
    pop si
    pop dx
    pop cx
    pop bx
    pop bp
    ret 6

start:
    mov ax,array1
    push ax
	mov ax,[size1]
    push ax
	mov ax,[key1]
    push ax
    call BinarySearch

    mov ax,array2
	push ax
    mov ax,[size2]
    push ax
	mov ax,[key2]
    push ax
    call BinarySearch

    mov ax,array3
	push ax
    mov ax,[size3]
    push ax
	mov ax,[key3]
    push ax
    call BinarySearch

    mov ax, 0x4c00
    int 0x21
