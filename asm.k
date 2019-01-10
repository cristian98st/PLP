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
                  | "add" Reg "," Var [strict]
                  | "sub" Reg "," Var [strict]
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
					<env> EAX |-> 1 EBX |->-1 ECX |-> -1 EDX |-> -1</env>
				  </T>
	
	rule L1:Line L2:Line => L1 ~> L2
	 
 
    rule <k> mov X:Reg, Y:Var  => . ...</k>
        <env>... X |-> (_=> Y)  ...</env>
        
endmodule