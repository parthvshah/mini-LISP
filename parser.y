%{
    #include <iostream>
    #include <string.h>
    #include <stack>
    #include <map>
    #include <cstdio>
    #include "ASTTree.hh"
    extern "C" {
        extern int yylex();
        void yyerror(const char *message);
    }
    extern int table_pointer;
    extern int my_stack[];
    extern int line_number;
    extern int setting_value;
    extern char* ERROR_TOKEN;
    extern void display();
%}
%union {
    int intVal;
    bool boolVal;
    char* id;
    Node *node;
}

%type <node> PROGRAM 
%type <node> STMT STMTS PRINT_STMT SET_STMT
%type <node> EXP  
%type <node> NUM_OP LOGICAL_OP 
%type <node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
%type <node> AND_OP OR_OP NOT_OP
%type <node> VARIABLE
%type <node> IF_EXP FROM IN RANGE

%token<intVal> _number
%token<boolVal> _bool_val
%token<id> _id _str
%token _print _setq _if _loopfor _loopwhile _do _in _from _to

%left '>' '<' '='
%left '+' '-' 
%left '*' '/' _mod 
%left _and _or _not
%left '(' ')' 

%%
PROGRAM             : STMT STMTS                                    {
                                                                        $$ = makeNode(2, "PROGRAM", $1, $2);
                                                                    }
                    | STMT                                          {
                                                                        $$ = makeNode(1, "PROGRAM", $1);
                                                                    }
                    ;
STMTS               : STMT STMTS                                    {
                                                                        $$ = makeNode(2, "STMTS" $1, $2);
                                                                    }
                    | STMT                                          {
                                                                        $$ = makeNode(1, "STMTS" $1);
                                                                    }
                    ;
STMT                : EXP                                           {
                                                                        $$ = makeNode(1, "STMT" $1);
                                                                    }
                    | SET_STMT                                      {
                                                                        $$ = makeNode(1, "STMT" $1);
                                                                    }
                    | PRINT_STMT                                    {
                                                                        $$ = makeNode(1, "STMT" $1);
                                                                    }
                    | IF_EXP                                        {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    | LOOPFOR_EXP                                   {
                                                                        $$ = makeNode(1, "STMT" $1);
                                                                    }
                    | LOOPWHILE_EXP                                 {
                                                                        $$ = makeNode(1, "STMT" $1);
                                                                    }
                    ;
PRINT_STMT          : '(' _print EXP ')'                            {
                                                                        $$ = makeNode(1, "PRINT_STMT" $1);
                                                                    }
                    ;
EXP                 : BOOL                                          {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    | NUM                                           {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    | STR                                           {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    | VARIABLE                                      {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    | NUM_OP                                        {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    | LOGICAL_OP                                    {
                                                                        $$ = makeNode(1, "EXP" $1);
                                                                    }
                    ;
NUM_OP              : PLUS                                          {
                                                                        $$ = makeNode(1,"NUM_OP", $1);
                                                                    }
                    | MINUS                                         {
                                                                        $$ = makeNode(1,"NUM_OP", $1);
                                                                    }
                    | MULTIPLY                                      {
                                                                        $$ = makeNode(1,"NUM_OP", $1);
                                                                    }
                    | DIVIDE                                        {
                                                                        $$ = makeNode(1,"NUM_OP", $1);
                                                                    }
                    | MODULES                                       {
                                                                        $$ = makeNode(1,"NUM_OP", $1);
                                                                    }
                    ;
        PLUS        : '(' '+' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "+", $1, $2);
                                                                    }
                    ;
        MINUS       : '(' '-' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "-", $1, $2);
                                                                    }
                    ;
        MULTIPLY    : '(' '*' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "*", $1, $2);
                                                                    }
                    ;
        DIVIDE      : '(' '/' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "/", $1, $2);
                                                                    }
                    ;
        MODULES     : '(' _mod EXP EXP ')'                          {
                                                                        $$ = makeNode(2, "%", $1, $2);
                                                                    }
                    ;
LOGICAL_OP          : AND_OP                                        {
                                                                        $$ = makeNode(1, "LOGICAL_OP" $1);
                                                                    }
                    | OR_OP                                         {
                                                                        $$ = makeNode(1, "LOGICAL_OP" $1);
                                                                    }
                    | NOT_OP                                        {
                                                                        $$ = makeNode(1, "LOGICAL_OP" $1);
                                                                    }
                    | GREATER                                       {
                                                                        $$ = makeNode(1,"LOGICAL_OP", $1);
                                                                    }
                    | SMALLER                                       {
                                                                        $$ = makeNode(1,"LOGICAL_OP", $1);
                                                                    }
                    | EQUAL                                         {
                                                                        $$ = makeNode(1,"LOGICAL_OP", $1);
                                                                    }
                    ;
        AND_OP      : '(' _and EXP EXP ')'                          {
                                                                        $$ = makeNode(2, "AND", $1, $2);
                                                                    }
                    ;
        OR_OP       : '(' _or EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "OR", $1, $2);
                                                                    }
                    ;
        NOT_OP      : '(' _not EXP ')'                              {
                                                                        $$ = makeNode(1, "NOT", $1);
                                                                    }
                    ;
        GREATER     : '(' '>' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, ">", $1, $2);
                                                                    }
                    ;
        SMALLER     : '(' '<' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "<", $1, $2);
                                                                    }
                    ;
        EQUAL       : '(' '=' EXP EXP ')'                           {
                                                                        $$ = makeNode(2, "=", $1, $2);
                                                                    }
                    ;
SET_STMT            : '(' _setq VARIABLE EXP ')'                    {
                                                                        $$ = makeNode(2, "SET_STMT", $1, $2);
                                                                    }
                    ;
    
IF_EXP              : '(' _if EXP STMT STMT ')'                     {
                                                                        $$ = makeNode(3, "IF_EXP", $1, $2, $3);
                                                                    }
                    ;
LOOPFOR_EXP         : '(' _loopfor IN STMTS ')'                     {
                                                                        $$ = makeNode(2, "LOOPFOR_EXP", $1, $2);
                                                                    } 
                    | '(' _loopfor FROM  STMTS ')'                  {
                                                                        $$ = makeNode(2, "LOOPFOR_EXP", $1, $2);
                                                                    } 
                    ;                  
FROM                : VARIABLE _from RANGE                          {
                                                                        $$ = makeNode(2, "FROM", $1, $2);
                                                                    } 
                    ;   
RANGE               : NUM _to NUM                                   {
                                                                        $$ = makeNode(2, "RANGE", $1, $2);
                                                                    } 
                    | NUM _to VARIABLE                              {
                                                                        $$ = makeNode(2, "RANGE", $1, $2);
                                                                    } 
                    | VARIABLE _to NUM                              {
                                                                        $$ = makeNode(2, "RANGE", $1, $2);
                                                                    } 
                    | VARIABLE _to VARIABLE                         {
                                                                        $$ = makeNode(2, "RANGE", $1, $2);
                                                                    } 
                    ;
IN                  : VARIABLE _in LIST                             {
                                                                        $$ = makeNode(2, "IN", $1, $2);
                                                                    } 
                    ;                    
LOOPWHILE_EXP       : '(' _loopwhile EXP STMTS ')'                  {
                                                                        $$ = makeNode(2, "LOOPWHILE_EXP", $1, $2);
                                                                    } 
                    ;
LIST                : '\'' '(' LISTELEM_STR ')'                     {
                                                                        $$ = makeNode(1, "LIST", $1);
                                                                    } 
                    | '(' LISTELEM_NUM ')'                          {
                                                                        $$ = makeNode(1, "LIST", $1);
                                                                    } 
                    ;
LISTELEM_NUM        : NUM LISTELEM_NUM                              {
                                                                        $$ = makeNode(2, "LISTELEM_NUM", $1, $2);
                                                                    } 
                    | NUM                                           {
                                                                        $$ = makeNode(1, "LISTELEM_NUM", $1);
                                                                    } 
                    ;
LISTELEM_STR        : STR LISTELEM_STR                              {
                                                                        $$ = makeNode(2, "LISTELEM_STR", $1, $2);
                                                                    } 
                    | STR                                           {
                                                                        $$ = makeNode(1, "LISTELEM_STR", $1);
                                                                    } 
                    ;
VARIABLE            : _id                                           {
                                                                        $1 = makeLeafNode(1, std::string($1))
                                                                        $$ = makeNode(1, "VARIABLE", $1);
                                                                    }
                    ;
NUM                 : _number                                       {
                                                                        $1 = makeLeafNode(1, $1)
                                                                        $$ = makeNode(1, "NUM", $1);
                                                                    }
                    ;
BOOL                : _bool_val                                     {
                                                                        $1 = makeLeafNode(1, $1)
                                                                        $$ = makeNode(1, "BOOL", $1);
                                                                    }
                    ;
STR                 : _str                                          {
                                                                        $1 = makeLeafNode(1, std::string($1))
                                                                        $$ = makeNode(1, "STR", $1);
                                                                    }
                    ;
%%

void yyerror(const char *message) {
    fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
    my_stack[0] = 0;
    setting_value = 0;
    table_pointer = 0;
    line_number = 1;
    if(yyparse()==1)
	{
        display();
		printf("Parsing failed\n");
	}
	else
	{
        display();
		printf("Parsing completed successfully\n");
	}
    return(0);
}


