MODULE ASM-SYNTAX            
    syntax Reg  ::= "EAX"
                  | "EBX"
                  | "ECX"
                  | "EDX"

    syntax Var  ::= Reg
                  | Id

    syntax AExp ::= Int
                  | Var 

    syntax BExp ::= Bool
                  | 

    syntax Op   ::= "mov" Var "," AExp
                  | "add" Var "," AExp
                  | "sub" Var "," AExp
                  | "mul" Var "," AExp
                  | "div" Var "," AExp
                  | "inc" Var 
                  | "dec" Var
                  | "and" Var "," AExp
                  | "or"  Var "," AExp
                  | "xor" Var "," AExp
                  | "not" Var
                  | "test" Var "," Aexp
