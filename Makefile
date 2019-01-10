all:
	kompile asm.k

clean:
	rm -r asm-kompiled

run:
	kast test.asm
	krun test.asm