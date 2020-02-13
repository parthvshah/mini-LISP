%{
    #include <iostream>
    #include <string>
    #include <stack>
    #include <map>
    #include <cstdio>
    extern "C" {
        extern int yylex();
        void yyerror(const char *message);
    }
%}
%union {
    int intVal;
    bool boolVal;
    char* id;
    // ASTNode *node;
}

%type<node> PROGRAM 
%type<node> STMT STMTS PRINT_STMT SET_STMT
%type<node> EXP EXPS 
%type<node> NUM_OP LOGICAL_OP 
%type<node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
%type<node> AND_OP OR_OP NOT_OP
%type<node> VARIABLE
%type<node> IF_EXP TEST_EXP THAN_EXP ELSE_EXP

%token<intVal> _number
%token<boolVal> _bool_val
%token<id> _id
%token _print _setq _if

%left '>' '<' '='
%left '+' '-' 
%left '*' '/' _mod 
%left _and _or _not
%left '(' ')' 

%%
PROGRAM         : STMT STMTS 
                ;
STMTS           : STMT STMTS 
                | 
                ;
STMT            : EXP {printf("EXP");}
                | SET_STMT {printf("SET_STMT");}
                | PRINT_STMT {printf("PRINT_STMT");}
                ;

PRINT_STMT      : '(' _print EXP ')' 
                ;
EXPS            : EXP EXPS 
                | 
                ;
EXP             : _bool_val {printf("BOOL");}
                | _number {printf("NUM");}
                | VARIABLE {printf("VAR");}
                | NUM_OP 
                | LOGICAL_OP 
                | IF_EXP
                ;
NUM_OP          : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS    : '(' '+' EXP EXP EXPS ')';
        MINUS   : '(' '-' EXP EXP ')';
        MULTIPLY: '(' '*' EXP EXP EXPS ')';
        DIVIDE  : '(' '/' EXP EXP ')';
        MODULES : '(' _mod EXP EXP ')';
        GREATER : '(' '>' EXP EXP ')';
        SMALLER : '(' '<' EXP EXP ')';
        EQUAL   : '(' '=' EXP EXP EXPS ')';

LOGICAL_OP      : AND_OP | OR_OP | NOT_OP ;
        AND_OP  : '(' _and EXP EXP EXPS ')';
        OR_OP   : '(' _or EXP EXP EXPS ')';
        NOT_OP  : '(' _not EXP ')';

SET_STMT        : '(' _setq VARIABLE EXP ')' 
                ;
        VARIABLE: _id 
                ;

IF_EXP          : '(' _if TEST_EXP THAN_EXP ELSE_EXP ')'
                ;
        TEST_EXP: EXP 
                ;
        THAN_EXP: EXP 
                ;
        ELSE_EXP: EXP 
                ;
%%

void yyerror(const char *message) {
    fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
    if(yyparse()==1)
	{
		printf("\nParsing failed\n");
	}
	else
	{
		printf("\nParsing completed successfully\n");
	}
    return(0);
}
