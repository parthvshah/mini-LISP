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
    FILE *icg_file;
    ASTNode *ast_root;
    int icg_line_number, icg_temp, icg_branch, icg_exit;
    void generate_code(ASTNode *);

%}
%union {
    int intVal;
    bool boolVal;
    char* id;
    char* str;
    ASTNode *node;
}

%type <node> PROGRAM 
%type <node> STMTS PRINT_STMT SET_STMT
%type <node> EXP  
%type <node> NUM_OP LOGICAL_OP 
%type <node> PLUS MINUS MULTIPLY DIVIDE MODULES GREATER SMALLER EQUAL
%type <node> AND_OP OR_OP NOT_OP
%type <node> VARIABLE
%type <node> IF_EXP FROM IN RANGE
%type <node> NUM STR BOOL LISTELEM_NUM LISTELEM_STR LIST
%type <node> LOOPFOR_EXP STMT LOOPWHILE_EXP

%token<intVal> _number
%token<boolVal> _bool_val
%token<id> _id
%token<str> _str
%token _print _setq _if _loopfor _loopwhile _do _in _from _to

%left '>' '<' '='
%left '+' '-' 
%left '*' '/' _mod 
%left _and _or _not
%left '(' ')' 

%start S

%%
S                   : PROGRAM                       {
                                                        ast_root = $1;
                                                    }
  	                ;
PROGRAM             : STMT STMTS                    {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "PROGRAM");
                                                        $$ = makeNode2(temp, $1, $2);
                                                    }
                    | STMT                          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "PROGRAM");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    ;
STMTS               : STMT STMTS                    {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMTS");
                                                        $$ = makeNode2(temp, $1, $2);
                                                    }
                    | STMT                          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMTS");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    ;
STMT                : EXP                           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMT");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | SET_STMT                      {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMT");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | PRINT_STMT                    {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMT");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | IF_EXP                        {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMT");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | LOOPFOR_EXP                   {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMT");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | LOOPWHILE_EXP                 {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STMT");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    ;
PRINT_STMT          : '(' _print EXP ')'            {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "PRINT_STMT");
                                                        $$ = makeNode1(temp, $3);
                                                    }
                    ;
EXP                 : BOOL                          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "EXP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | NUM                           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "EXP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | STR                           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "EXP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | VARIABLE                      {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "EXP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | NUM_OP                        {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "EXP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | LOGICAL_OP                    {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "EXP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    ;
NUM_OP              : PLUS                          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NUM_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | MINUS                         {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NUM_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | MULTIPLY                      {
                                                        printf("%s", "Multi");
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NUM_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | DIVIDE                        {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NUM_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | MODULES                       {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NUM_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    ;
        PLUS        : '(' '+' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "+");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        MINUS       : '(' '-' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "-");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        MULTIPLY    : '(' '*' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "*");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        DIVIDE      : '(' '/' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "/");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        MODULES     : '(' _mod EXP EXP ')'          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "%");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
LOGICAL_OP          : AND_OP                        {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOGICAL_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | OR_OP                         {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOGICAL_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | NOT_OP                        {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOGICAL_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | GREATER                       {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOGICAL_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | SMALLER                       {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOGICAL_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    | EQUAL                         {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOGICAL_OP");
                                                        $$ = makeNode1(temp, $1);
                                                    }
                    ;
        AND_OP      : '(' _and EXP EXP ')'          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "AND");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        OR_OP       : '(' _or EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "OR");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        NOT_OP      : '(' _not EXP ')'              {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NOT");
                                                        $$ = makeNode1(temp, $3);
                                                    }
                    ;
        GREATER     : '(' '>' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, ">");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        SMALLER     : '(' '<' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "<");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
        EQUAL       : '(' '=' EXP EXP ')'           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "=");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
SET_STMT            : '(' _setq VARIABLE EXP ')'    {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "SET_STMT");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    }
                    ;
    
IF_EXP              : '(' _if EXP STMT STMT ')'     {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "IF_EXP");
                                                        $$ = makeNode3(temp, $3, $4, $5);
                                                    }
                    ;
LOOPFOR_EXP         : '(' _loopfor IN STMTS ')'     {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOOPFOR_EXP");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    } 
                    | '(' _loopfor FROM  STMTS ')'  {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOOPFOR_EXP");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    } 
                    ;                  
FROM                : VARIABLE _from RANGE          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "FROM");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    ;   
RANGE               : NUM _to NUM                   {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "RANGE");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    | NUM _to VARIABLE              {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "RANGE");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    | VARIABLE _to NUM              {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "RANGE");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    | VARIABLE _to VARIABLE         {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "RANGE");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    ;
IN                  : VARIABLE _in LIST             {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "IN");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    ;                    
LOOPWHILE_EXP       : '(' _loopwhile EXP STMTS ')'  {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOOPWHILE_EXP");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    } 
                    ;
LIST                : '\'' '(' LISTELEM_STR ')'     {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LIST");
                                                        $$ = makeNode1(temp, $3);
                                                    } 
                    | '(' LISTELEM_NUM ')'          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LIST");
                                                        $$ = makeNode1(temp, $2);
                                                    } 
                    ;
LISTELEM_NUM        : NUM LISTELEM_NUM              {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LISTELEM_NUM");
                                                        $$ = makeNode2(temp, $1, $2);
                                                    } 
                    | NUM                           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LISTELEM_NUM");
                                                        $$ = makeNode1(temp, $1);
                                                    } 
                    ;
LISTELEM_STR        : STR LISTELEM_STR              {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LISTELEM_STR");
                                                        $$ = makeNode2(temp, $1, $2);
                                                    } 
                    | STR                           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LISTELEM_STR");
                                                        $$ = makeNode1(temp, $1);
                                                    } 
                    ;
VARIABLE            : _id                           {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "VARIABLE");
                                                        ASTNode *t = makeLeafNode_id($1);
                                                        $$ = makeNode1(temp, t);
                                                    }
                    ;
NUM                 : _number                       {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "NUM");
                                                        ASTNode *t = makeLeafNode_num($1);
                                                        $$ = makeNode1(temp, t);
                                                    }
                    ;
BOOL                : _bool_val                     {   
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "BOOL");
                                                        ASTNode *t = makeLeafNode_bool($1);
                                                        $$ = makeNode1(temp, t);
                                                    }
                    ;
STR                 : _str                          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "STR");
                                                        ASTNode *t = makeLeafNode_str($1);
                                                        $$ = makeNode1(temp, t);
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
    ERROR_TOKEN = (char *)malloc(sizeof(char)*15);
    strcpy(ERROR_TOKEN, "Error_Token");
    icg_line_number = 0;
    icg_branch = 0;
    icg_exit = 0;
    icg_temp = 0;
	icg_file = fopen("icg.txt", "w");
    if(yyparse()==1)
	{
        // display();
		printf("Parsing failed\n");
	}
	else
	{
        // display();
		printf("Parsing completed successfully\n");
        generate_code(ast_root);
	}

	fclose(icg_file);
    printf("Printing IC:\n\n");
	system("cat icg.txt");
    printf("\n\n");
    return(0);
}

void generate_code(ASTNode *root)
{
    switch(root->type)
    {
        case 1: if(strcmp(root->ope, "PRINT_STMT") == 0)
                {
                    fprintf(icg_file, "\n( print ");
                    generate_code(root->child[0]);
                    fprintf(icg_file, ")\n ");
                }
                else if( strcmp(root->ope, "+") == 0 || strcmp(root->ope, "-") == 0 || strcmp(root->ope, "*") == 0 || strcmp(root->ope, "/") == 0 || strcmp(root->ope, "%") == 0)
                {
                    fprintf(icg_file, "( ");
                    generate_code(root->child[0]);
                    fprintf(icg_file, " %s ", root->ope);
                    generate_code(root->child[1]);
                    fprintf(icg_file, " )");
                }
                else if( strcmp(root->ope, "<") == 0 || strcmp(root->ope, ">") == 0 || strcmp(root->ope, "=") == 0 || strcmp(root->ope, "AND") == 0 || strcmp(root->ope, "OR") == 0)
                {
                    fprintf(icg_file, "( ");
                    generate_code(root->child[0]);
                    fprintf(icg_file, " %s ", root->ope);
                    generate_code(root->child[1]);
                    fprintf(icg_file, " )");
                }
                else if( strcmp(root->ope, "NOT") == 0)
                {
                    fprintf(icg_file, "!");
                    generate_code(root->child[0]);
                }
                else if( strcmp(root->ope, "SET_STMT") == 0)
                {
                    fprintf(icg_file, "\n");
                    generate_code(root->child[0]);
                    fprintf(icg_file, " = ");
                    generate_code(root->child[1]);
                    fprintf(icg_file, "\n");
                }
                else
                {
                    for(int i=0 ; i<root->number_of_children ; i++)
                    {
                        generate_code(root->child[i]);
                    }
                }
                break;
        case 2:
                fprintf(icg_file, "%s", root->id);
                break;
        case 3:
                fprintf(icg_file, "%d", root->num_value);
                break;
        case 4:
                fprintf(icg_file, "%d", root->bool_value);
                break;
        case 5:
                fprintf(icg_file, "%s", root->str_value);
                break;
    }
}

