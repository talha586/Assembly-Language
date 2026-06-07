[org 0x0100]

mov ax,0         
mov bx,1         
mov cx,[s]       
mov si,Fib  
      
mov [si],ax
add si,2
sub cx,1

mov [si],bx       
add si,2
sub cx,1        

l1:     
   add ax,bx      
   mov [si],ax    
   add si,2
   mov ax,bx      
   mov bx,[si-2]  
   
   sub cx,1
   jnz l1

mov ax,0x4c00
int 0x21

s : dw 10
Fib : dw 0,0,0,0,0,0,0,0,0,0