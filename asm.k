module ASM-SYNTAX            
    syntax Reg  ::= "EAX"
                  | "EBX"
                  | "ECX"
                  | "EDX"

    syntax Var  ::= Reg
                  | Int

    syntax AExp ::= Id

    syntax BExp ::= "cmp" Reg "," Var Jump

    syntax Jump ::= "jmp" Func Line Func Op [right]
                  | "je" Func Line Func Line
                  | "jne" Func Line Func Line
                  | "jg" Func Line Func Line
                  | "jge" Func Line Func Line
                  | "jl" Func Line Func Line
                  | "jle" Func Line Func Line
                  | Func Line "loop" Func Op

    syntax Op   ::= "mov" Reg "," Var [strict (2)]
                  | "add" Reg "," Var [left, strict(2)]
                  | "sub" Reg "," Var [left, strict(2)]
                  | "mul" Reg "," Var [left, strict(2)]
                  | "div" Reg "," Var [left, strict(2)]
                  | "inc" Reg [strict]
                  | "dec" Reg [strict]
                  | "and" Reg "," Var
                  | "or"  Reg "," Var
                  | "xor" Reg "," Var
                  | "not" Reg
                  | "test" Reg "," Reg

    syntax Extra::= "read" Reg
                  | "print" Reg

    syntax Func ::= "_."AExp
                
    syntax Line ::= BExp
                    | Op
                    | Extra
                    | Func
                    | Jump
                    > Line Line [right]

endmodule

module ASM 
	imports ASM-SYNTAX
	
	syntax KResult ::= Int
	configuration <T>
					<k> $PGM:Line </k>
					<env> EAX |-> -2 EBX |->-1 ECX |-> -1 EDX |-> -1</env>
				  </T>
	
	rule L1:Line L2:Line => L1 ~> L2
	 
    rule <k> (X:Reg => V) ...</k>
        <env>... X |-> V:Int ..</env>

 // mov Function
    rule <k> mov X:Reg, Y1:Int  => . ...</k>
        <env>... X |-> (_=> Y1)  ...</env>
        
    rule <k> mov X:Reg, Y2:Reg => . ...</k>
        <env>... X |-> (_=> Z) Y2 |-> Z:Int ...</env>

    // rule <k> add R:Reg, Y1:Int =>. ...</k>
    //     <env>... R |-> (_=> V:Int) V |-> (Z +Int Y1)  R |-> Z:Int...</env>

// add op
    rule <k> (add R:Reg, Y1:Int => .) ...</k>
        <env>... R |-> (Z:Int=> Z +Int Y1) ...</env>

    rule <k> (add R1:Reg, Y2:Reg => .) ...</k>
        <env>... R1 |-> (V:Int=> V +Int Z) Y2 |-> Z:Int ...</env>

// sub op
    rule <k> (sub R:Reg, Y1:Int => .) ...</k>
        <env>... R |-> (Z:Int=> Z -Int Y1) ...</env>

    rule <k> (sub R1:Reg, Y2:Reg =>.) ...</k>
        <env>... R1 |-> (V:Int=> V -Int Z) Y2 |-> Z:Int ...</env>

// mul op
    rule <k> (mul R:Reg, Y1:Int => .) ...</k>
        <env>... R |-> (Z:Int=> Z *Int Y1) ...</env>

    rule <k> (mul R:Reg, Y:Reg => .) ...</k>
        <env>... R |-> (X:Int=> X *Int Z) Y |-> Z:Int ...</env>

// div op
    rule <k> (div R:Reg, Y1:Int => .) ...</k>
        <env>... R |-> (Z:Int=> Z /Int Y1) ...</env>

    rule <k> (div R:Reg, Y:Reg => .) ...</k>
        <env>... R |-> (X:Int=> X /Int Z) Y |-> Z:Int ...</env>

// inc op
    rule <k> (inc R:Reg => .) ...</k>
        <env>... R |-> (Z:Int=> Z +Int 1) ...</env>

// dec op
    rule <k> (dec R:Reg => .) ...</k>
        <env>... R |-> (Z:Int=> Z -Int 1) ...</env>

// jmp
    rule <k> jmp L:Func O1:Line L O2:Op => O2 ...</k>

// loop
   // rule <k>  L:Func O1:Line loop L O2:Op => L~>O1 ...</k>

endmodule