%{
    #include <iostream>
    #include <string.h>
    #include <stack>
    #include <map>
    #include <cstdio>
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

    typedef struct Node{
        int number_of_children;
		struct Node *child[10];
		char ope[16];
        int type;
        /*
            0 - NULL value
            1 - operator - for/while/if/+/-....
            2 - id
            3 - number value
            4 - bool value
            5 - string value
        */
		char id[100];
		int num_value;
        char bool_value;
        char *str_value;
	}Node;
    Node *root;

%}
%union {
    int intVal;
    bool boolVal;
    char* id;
}

%type<node> PROGRAM 
%type<node> STMT STMTS PRINT_STMT SET_STMT
%type<node> EXP  
%type<node> NUM_OP LOGICAL_OP 
%type<node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
%type<node> AND_OP OR_OP NOT_OP
%type<node> VARIABLE
%type<node> IF_EXP TEST_EXP THAN_EXP ELSE_EXP

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
PROGRAM             : STMT STMTS 
                    | STMT
                    ;
STMTS               : STMT STMTS 
                    | STMT
                    ;
STMT                : EXP 
                    | SET_STMT 
                    | PRINT_STMT 
                    | LOOPFOR_EXP 
                    | LOOPWHILE_EXP 
                    ;
    
PRINT_STMT          : '(' _print EXP ')' 
                    ;

EXP                 : _bool_val 
                    | _number 
                    | _str 
                    | VARIABLE 
                    | NUM_OP 
                    | LOGICAL_OP 
                    | IF_EXP
                    ;
NUM_OP              : PLUS | MINUS | MULTIPLY | DIVIDE | MODULES | GREATER | SMALLER | EQUAL ;
        PLUS        : '(' '+' EXP EXP ')';
        MINUS       : '(' '-' EXP EXP ')';
        MULTIPLY    : '(' '*' EXP EXP ')';
        DIVIDE      : '(' '/' EXP EXP ')';
        MODULES     : '(' _mod EXP EXP ')';
        GREATER     : '(' '>' EXP EXP ')';
        SMALLER     : '(' '<' EXP EXP ')';
        EQUAL       : '(' '=' EXP EXP ')';
    
LOGICAL_OP          : AND_OP | OR_OP | NOT_OP ;
        AND_OP      : '(' _and EXP EXP ')';
        OR_OP       : '(' _or EXP EXP ')';
        NOT_OP      : '(' _not EXP ')';
    
SET_STMT            : '(' _setq VARIABLE EXP ')' 
                    ;
        VARIABLE    : _id 
                    ;
    
IF_EXP              : '(' _if TEST_EXP THAN_EXP ELSE_EXP ')'
                    ;
        TEST_EXP    : STMT 
                    ;
        THAN_EXP    : STMT 
                    ;
        ELSE_EXP    : STMT 
                    ;
LOOPFOR_EXP         : '(' _loopfor _id _in LIST STMTS ')'
                    | '(' _loopfor _id _from _number _to _number STMTS ')'
                    | '(' _loopfor _id _from _number _to _id STMTS ')'
                    | '(' _loopfor _id _from _id _to _number STMTS ')'
                    | '(' _loopfor _id _from _id _to _id STMTS ')'
                    ;
LOOPWHILE_EXP       : '(' _loopwhile TEST_EXP STMTS ')'
                    ;
LIST                : '\'' '(' LISTELEM_STR ')'
                    | '(' LISTELEM_NUM ')'
                    ;
LISTELEM_NUM        : _number LISTELEM_NUM
                    | _number
                    ;
LISTELEM_STR        : _str LISTELEM_STR
                    | _str
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
    stack_top = -1;
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


