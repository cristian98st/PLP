mov EAX, 20
mov EBX, EAX
mov ECX, EAX
add EBX, 2
add ECX, EBX
sub ECX, 2

_. back
mul EAX, 2
inc EAX
jmp _.dest

loop _.back

_.dest
mov EBX, EAX
inc ECX
