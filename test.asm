mov EAX, 20
mov EBX, EAX
mov ECX, EAX
add EBX, 2
add ECX, EBX
sub ECX, 2
jmp _.dest

mov EAX, EBX
inc EDX

_.back
mov EAX, EBX
inc EAX

_.dest
mul EBX, 2
inc ECX
inc ECX
