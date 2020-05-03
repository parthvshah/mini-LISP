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
    extern struct row symtab[256];
    extern char* ERROR_TOKEN;
    extern void display();
    FILE *icg_file;
    ASTNode *ast_root;
    int icg_line_number, icg_temp, icg_branch, icg_exit;
    int generate_code(ASTNode *);
    void print_code(ASTNode *);
    void loop_unfolder(ASTNode *, int, int);
    // void print_id(ASTNode *);
    // int print_id_value(char *);

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
%type <node> IF_EXP FROM RANGE
%type <node> NUM STR BOOL
%type <node> LOOPFOR_FROM STMT LOOPWHILE_EXP

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
                    | LOOPFOR_FROM                  {
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
LOOPFOR_FROM    : '(' _loopfor FROM  STMTS ')'      {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOOPFOR_FROM");
                                                        $$ = makeNode2(temp, $3, $4);
                                                    } 
                    ;                  
FROM                : VARIABLE _from RANGE          {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "FROM");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    ;   
RANGE               : EXP _to EXP                   {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "RANGE");
                                                        $$ = makeNode2(temp, $1, $3);
                                                    } 
                    ;                   
LOOPWHILE_EXP       : '(' _loopwhile EXP STMTS ')'  {
                                                        char *temp = (char *)malloc(sizeof(char)*15);
                                                        strcpy(temp, "LOOPWHILE_EXP");
                                                        $$ = makeNode2(temp, $3, $4);
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
        display();
		printf("Parsing failed\n");
	}
	else
	{
        display();
		printf("Parsing completed successfully\n");
        generate_code(ast_root);
	}

	fclose(icg_file);
    printf("Printing IC:\n\n");
	system("cat icg.txt");
    printf("\n\n");
    return(0);
}

int generate_code(ASTNode *root)
{
    if(root->type == 1)
    {       
        if( strcmp(root->ope, "PRINT_STMT") == 0 )
        {
            int op0 = generate_code(root->child[0]);
            fprintf(icg_file, "print ( ");
            if( op0 > 0)
            {
                fprintf(icg_file, "t%d", op0);
            }
            else
            {
                print_code(root->child[0]);
            }
            fprintf(icg_file, " )\n");
        }
        else if( strcmp(root->ope, "+") == 0 || strcmp(root->ope, "-") == 0 || strcmp(root->ope, "*") == 0 || strcmp(root->ope, "/") == 0 || strcmp(root->ope, "%") == 0 || strcmp(root->ope, "<") == 0 || strcmp(root->ope, ">") == 0)
        {
            int tempvar = ++icg_temp;
            int op0 = generate_code(root->child[0]);
            int op1 = generate_code(root->child[1]);
            fprintf(icg_file, "t%d = ", tempvar);
            if( op0 > 0)
            {
                fprintf(icg_file, "t%d", op0);
            }
            else
            {
                print_code(root->child[0]);
            }
            fprintf(icg_file, " %s ", root->ope);
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[1]);
            }
            fprintf(icg_file, "\n");
            return tempvar;
        }
        else if( strcmp(root->ope, "=") == 0 )
        {
            int tempvar = ++icg_temp;
            int op0 = generate_code(root->child[0]);
            int op1 = generate_code(root->child[1]);
            fprintf(icg_file, "t%d = ", tempvar);
            if( op0 > 0)
            {
                fprintf(icg_file, "t%d", op0);
            }
            else
            {
                print_code(root->child[0]);
            }
            fprintf(icg_file, " == ");
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[1]);
            }
            fprintf(icg_file, "\n");
            return tempvar;
        }
        else if( strcmp(root->ope, "AND") == 0 )
        {
            int tempvar = ++icg_temp;
            int op0 = generate_code(root->child[0]);
            int op1 = generate_code(root->child[1]);
            fprintf(icg_file, "t%d = ", tempvar);
            if( op0 > 0)
            {
                fprintf(icg_file, "t%d", op0);
            }
            else
            {
                print_code(root->child[0]);
            }
            fprintf(icg_file, " && ");
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[1]);
            }
            fprintf(icg_file, "\n");
            return tempvar;
        }
        else if( strcmp(root->ope, "OR") == 0)
        {
            int tempvar = ++icg_temp;
            int op0 = generate_code(root->child[0]);
            int op1 = generate_code(root->child[1]);
            fprintf(icg_file, "t%d = ", tempvar);
            if( op0 > 0)
            {
                fprintf(icg_file, "t%d", op0);
            }
            else
            {
                print_code(root->child[0]);
            }
            fprintf(icg_file, " || ");
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[1]);
            }
            fprintf(icg_file, "\n");
            return tempvar;
        }
        else if( strcmp(root->ope, "NOT") == 0)
        {
            int tempvar = ++icg_temp;
            int notvar = ++icg_temp;
            int op0 = generate_code(root->child[0]);
            if( op0 <= 0)
            {
                fprintf(icg_file, "t%d = ", notvar);
                print_code(root->child[0]);
                fprintf(icg_file, "\n");
            }
            fprintf(icg_file, "t%d = ! ", tempvar);
            if( op0 > 0)
            {
                fprintf(icg_file, "t%d", op0);
            }
            else
            {
                fprintf(icg_file, "t%d", notvar);
            }
            fprintf(icg_file, "\n");
            return tempvar;
        }
        else if( strcmp(root->ope, "SET_STMT") == 0 )
        {
            int op1 = generate_code(root->child[1]);
            print_code(root->child[0]);
            fprintf(icg_file, " = ");
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[1]);
            }
            fprintf(icg_file, "\n");
        }
        else if( strcmp(root->ope, "IF_EXP") == 0 )
        {
            int op1 = generate_code(root->child[0]);
            fprintf(icg_file, "if ");
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[1]);
            }
            fprintf(icg_file, "\n");
            int branch1 = ++icg_branch;
            int branch2 = ++icg_branch;
            int exit = ++icg_exit;
            fprintf(icg_file, "GOTO L%d\n", branch1);
            fprintf(icg_file, "GOTO L%d\n", branch2);
            fprintf(icg_file, "L%d :\n", branch1);
            generate_code(root->child[1]);
            fprintf(icg_file, "GOTO EXIT%d\n", exit);
            fprintf(icg_file, "L%d :\n", branch2);
            generate_code(root->child[2]);
            fprintf(icg_file, "EXIT%d :\n", exit);
        }
        else if( strcmp(root->ope, "LOOPWHILE_EXP" ) == 0)
        {
            int loop_branch = ++icg_branch;
            int exit = ++icg_exit;
            fprintf(icg_file, "L%d :\n", loop_branch);
            int op1 = generate_code(root->child[0]);
            fprintf(icg_file, "if ");
            if( op1 > 0)
            {
                fprintf(icg_file, "t%d", op1);
            }
            else
            {
                print_code(root->child[0]);
            }
            fprintf(icg_file, "\n");
            int statement_branch = ++icg_branch;
            fprintf(icg_file, "GOTO L%d\n", statement_branch);
            fprintf(icg_file, "GOTO EXIT%d\n", exit);
            fprintf(icg_file, "L%d :\n", statement_branch);
            generate_code(root->child[1]);
            fprintf(icg_file, "GOTO L%d\n", loop_branch);
            fprintf(icg_file, "EXIT%d :\n", exit);
        }
        else if( strcmp(root->ope, "LOOPFOR_FROM") == 0 )
        {
            int start_temp_var = ++icg_temp;
            int end_temp_var = ++icg_temp;
            int start_num = generate_code(root->child[0]->child[1]->child[0]);
            int end_num = generate_code(root->child[0]->child[1]->child[1]);

            if(start_num == 0 && end_num == 0)
            {
                if(root->child[0]->child[1]->child[0]->child[0]->child[0]->type == 3 && root->child[0]->child[1]->child[1]->child[0]->child[0]->type == 3)
                {   
                    int start = root->child[0]->child[1]->child[0]->child[0]->child[0]->num_value;
                    int end = root->child[0]->child[1]->child[1]->child[0]->child[0]->num_value;
                    loop_unfolder(root, start, end);
                    return 0 ;
                }
            }

            fprintf(icg_file, "t%d = ", start_temp_var);
            if( start_num > 0)
            {
                fprintf(icg_file, "t%d", start_num);
            }
            else
            {
                print_code(root->child[0]->child[1]->child[0]);
            }
            fprintf(icg_file, "\n");
            fprintf(icg_file, "t%d = ", end_temp_var);
            if( end_num > 0)
            {
                fprintf(icg_file, "t%d", end_num);
            }
            else
            {
                print_code(root->child[0]->child[1]->child[1]);
            }
            fprintf(icg_file, "\n");
            print_code(root->child[0]->child[0]);
            fprintf(icg_file, " = t%d\n", start_temp_var);
            int loop_branch = ++icg_branch;
            int statement_branch = ++icg_branch;
            int exit = ++icg_exit;
            int condition = ++icg_temp;
            fprintf(icg_file, "L%d :\n", loop_branch);
            fprintf(icg_file, "t%d = ", condition);
            print_code(root->child[0]->child[0]);
            fprintf(icg_file, " < t%d\n", end_temp_var);
            fprintf(icg_file, "if t%d\n", condition);
            fprintf(icg_file, "GOTO L%d\n", statement_branch);
            fprintf(icg_file, "GOTO EXIT%d\n", exit);
            fprintf(icg_file, "L%d :\n", statement_branch);
            generate_code(root->child[1]);
            fprintf(icg_file, "t%d = t%d + 1\n", start_temp_var, start_temp_var);
            print_code(root->child[0]->child[0]);
            fprintf(icg_file, " = ");
            fprintf(icg_file, "t%d\n", start_temp_var);
            fprintf(icg_file, "GOTO L%d\n", loop_branch);
            fprintf(icg_file, "EXIT%d :\n", exit);
        }
        else
        {
            int return_value = generate_code(root->child[0]);
            for(int i=1 ; i<root->number_of_children ; i++)
            {
                generate_code(root->child[i]);
            }
            return return_value;
        }
    }
    return 0;
}

void print_code(ASTNode *root)
{
    switch(root->type)
    {
        case 1: 
                for(int i=0 ; i<root->number_of_children ; i++)
                {
                    print_code(root->child[i]);
                }
                break;
        case 2: 
                // if(!print_id_value(root->id))
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


void loop_unfolder(ASTNode *root, int start, int end)
{
    if (start<end)
    {
        for( int i=start ; i<end ; i++)
        {
            print_code(root->child[0]->child[0]);
            fprintf(icg_file, " = %d\n", i);
            generate_code(root->child[1]);
            fprintf(icg_file, "\n");
        }
    }
    else
    {
        for( int i=start ; i>end ; i--)
        {
            print_code(root->child[0]->child[0]);
            fprintf(icg_file, " = %d\n", i);
            generate_code(root->child[1]);
            fprintf(icg_file, "\n");
        }
    }
}

// void print_id(ASTNode *root)
// {
//     switch(root->type)
//     {
//         case 1: 
//                 for(int i=0 ; i<root->number_of_children ; i++)
//                 {
//                     print_id(root->child[i]);
//                 }
//                 break;
//         case 2:
//                 fprintf(icg_file, "%s", root->id);
//                 break;
//     }
// }
// int print_id_value(char *id_value)
// {
//     int temp = table_pointer-1;
//     while (temp>=0) 
//     {
//         if(strcmp(symtab[temp].id, id_value) == 0 && symtab[temp].scope == 0)
//         {
//             // fprintf(icg_file, "\nID VALUE FOUND");
//             if(symtab[temp].valid_value == 1)
//             {
//                 // fprintf(icg_file, "\nID VALUE \n");
//                 switch(symtab[temp].type)
//                 {
//                     case 1: fprintf(icg_file, "%d", symtab[temp].num_value);
//                             break;
//                     case 2: fprintf(icg_file, "%c", symtab[temp].bool_value);
//                             break;
//                     case 3: fprintf(icg_file, "%s", symtab[temp].str_value);
//                             break;
//                 }
//                 return 1;
//             }
//             return 0;
//         }
//         temp--;
//     }
//     return 0;
// }