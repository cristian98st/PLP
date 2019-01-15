module ASM-SYNTAX            
    syntax Reg  ::= "EAX"
                  | "EBX"
                  | "ECX"
                  | "EDX"

    syntax Var  ::= Reg
                  | Int

    syntax Name ::= Id    

    syntax BExp ::= Var "," Var "jle" [strict]
                  | Bool

    syntax JumpC ::= "je" 
                  | "jne" Func Line Func Line
                  | "jg" Func Line Func Line
                  | "jge" Func Line Func Line
                  | "jl" Func Line Func Line
                //   | "jle" Func Line Func Line
            
    syntax Jump  ::="jmp" Func Line Func Line
                //| Func Line "loop" Func
                  |"cmp" BExp Func Line Func Line

    syntax Op   ::= "mov" Reg "," MOV [strict (2)]
                  | "add" Reg "," Var [left, strict(2)]
                  | "sub" Reg "," Var [left, strict(2)]
                  | "mul" Reg "," Var [left, strict(2)]
                  | "div" Reg "," Var [left, strict(2)]
                  | "inc" Reg
                  | "dec" Reg
                  | "and" Reg "," Var
                  | "or"  Reg "," Var
                  | "xor" Reg "," Var
                  | "not" Reg
                  | "test" Reg "," Reg

    syntax MOV ::= READ
                  | Var

    syntax READ::= "read"
    syntax PRINT::= "print" Reg

    syntax Func ::= "-"Name
                
    syntax Line ::= BExp
                    | Op
                    | PRINT
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
                    <stack> .List </stack>
                    <in stream="stdin"> .List </in>
                    <out stream="stdout"> .List </out>
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

// Func
    rule <k> - N:Name L7:Line => L7 ...</k>

// jmp
    rule <k> jmp L:Func O1:Line L O2:Line => O2 ...</k>

// loop
   // rule <k>  L:Func O1:Line loop L => L~>O1 ...</k>

// cmp
    rule cmp true F1:Func L1:Line F1 L2:Line => L2
    rule cmp false F1:Func L1:Line F1 L2:Line => L1

// jle
    rule X:Int , Y:Int jle => X <=Int Y

//boolean rules

    // rule (not T:Int) => -Bool T

    // rule (true and B:Int) => B

    // rule (false and _) => false

// read
    rule <k> (read => V) ...</k>
       <in> (ListItem(V:Int) => .List) ...</in>

       
endmodule