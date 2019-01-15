mov EAX, 10
mov EDX, 40
mov EBX, read
jmp -dest

mov EAX, EDX

-dest
mov EDX, 100
inc EDX

-out
inc ECX