module ASM-SYNTAX            
    syntax Reg  ::= "EAX"
                  | "EBX"
                  | "ECX"
                  | "EDX"

    syntax Var  ::= Reg
                  | Int

    syntax AExp ::= Id

    syntax BExp ::= Bool
                  | "cmp" Reg "," Var

    syntax Op   ::= "mov" Reg "," Var [strict (2)]
                  | "add" Reg "," Var [left]
                  | "sub" Reg "," Var [left]
                  | "mul" Reg "," Var [strict]
                  | "div" Reg "," Var [strict]
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

// add Function:
    rule <k> (add R:Reg, Y1:Int =>.) ...</k>
        <env>... R |-> (Z:Int=> Z +Int Y1) ...</env>

    rule <k> (add R1:Reg, Y2:Reg => .) ...</k>
        <env>... R1 |-> (V:Int=> V +Int Z) Y2 |-> Z:Int ...</env>

// sub Function
    rule <k> (sub R:Reg, Y1:Int =>.) ...</k>
        <env>... R |-> (Z:Int=> Z -Int Y1) ...</env>

    rule <k> (sub R1:Reg, Y2:Reg =>.) ...</k>
        <env>... R1 |-> (V:Int=> V -Int Z) Y2 |-> Z:Int ...</env>

endmodule