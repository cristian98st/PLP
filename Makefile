all:
	kompile asm.k

clean:
	rm -r asm-kompiled

run:
	kast test.asm
	krun test.asm

test:
	kompile asm.k
	krun test.asm
