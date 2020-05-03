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
    FILE *final_file;
    ASTNode *ast_root;
    int as_branch_number;
    int as_exit_number;
    char register_queue[13][128];
    int register_front;
    int register_filled;
    int USE = 13;
    int get_register_value(char *, int);
    int generate_code(ASTNode *);
    int generate_code_operations(ASTNode *, int);

%}
%union {
    int intVal;
    char* id;
    char* str;
    ASTNode *node;
}

%type <node>  S supreme_start start opr T_STRING T_IDENTIFIER DATA_TYPE
%token T_MOD_OP T_OR_OP T_NE_OP T_AND_OP T_EQUAL T_GOTO T_NOT T_IF T_COLON T_EQ_OP T_PRINT 

%token<intVal> O_NUMBER
%token<id> O_IDENTIFIER
%token<str> O_STRING



%start S

%%
S : supreme_start   					    {
                                                ast_root = $1;
                                            }
    ;
supreme_start
	:start supreme_start   					{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "START_FOL");
                                                $$ = makeNode2(temp, $1, $2);
                                            }
	|start   					            {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "START");
                                                $$ = makeNode1(temp, $1);
                                            }
	;

start
	:T_PRINT T_STRING   					{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "PRINT");
                                                $$ = makeNode1(temp, $2);
                                            }
	|T_PRINT DATA_TYPE   					{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "PRINT");
                                                $$ = makeNode1(temp, $2);
                                            }
	|T_IDENTIFIER T_EQUAL T_NOT DATA_TYPE	{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "EQ_N_DT");
                                                $$ = makeNode2(temp, $1, $4);
                                            }
	|T_IDENTIFIER T_EQUAL T_STRING  		{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "EQ_STR");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	|T_IDENTIFIER T_EQUAL DATA_TYPE 		{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "EQ_DT");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	|T_IDENTIFIER T_EQUAL opr			 	{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "EQ_OPR");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	|T_GOTO T_IDENTIFIER 					{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "GOTO");
                                                $$ = makeNode1(temp, $2);
                                            }
	|T_IF T_IDENTIFIER T_GOTO T_IDENTIFIER 	{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "IF_GOTO");
                                                $$ = makeNode2(temp, $2, $4);
                                            }
	|T_IDENTIFIER T_COLON 					{
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "BRANCH");
                                                $$ = makeNode1(temp, $1);
                                            }
	;

opr 
    : DATA_TYPE '+' DATA_TYPE               {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "+");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE '-' DATA_TYPE               {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "-");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE '*' DATA_TYPE               {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "*");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE '/' DATA_TYPE               {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "/");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE '<' DATA_TYPE               {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "<");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE '>' DATA_TYPE               {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, ">");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE T_MOD_OP DATA_TYPE          {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "MOD");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE T_EQ_OP DATA_TYPE           {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "EQUAL_TO");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE T_OR_OP DATA_TYPE           {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "OR");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	| DATA_TYPE T_AND_OP DATA_TYPE          {
                                                char *temp = (char *)malloc(sizeof(char)*10);
                                                strcpy(temp, "AND");
                                                $$ = makeNode2(temp, $1, $3);
                                            }
	;

DATA_TYPE
    :O_NUMBER                               {
                                                char *temp = (char *)malloc(sizeof(char)*15);
                                                strcpy(temp, "NUMBER");
                                                ASTNode *t = makeLeafNode_num($1);
                                                $$ = makeNode1(temp, t);
                                            }
    |O_IDENTIFIER                           {
                                                char *temp = (char *)malloc(sizeof(char)*15);
                                                strcpy(temp, "ID");
                                                ASTNode *t = makeLeafNode_id($1);
                                                $$ = makeNode1(temp, t);
                                            }
    ;
T_IDENTIFIER
    :O_IDENTIFIER                           {
                                                char *temp = (char *)malloc(sizeof(char)*15);
                                                strcpy(temp, "ID");
                                                ASTNode *t = makeLeafNode_id($1);
                                                $$ = makeNode1(temp, t);
                                            }
    ;
T_STRING
    :O_STRING                               {
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
    as_branch_number = 0;
    as_exit_number = 0;
    for(int i=0; i<USE; i++)
    {

        strcpy(register_queue[i],"");
    }
    register_front = -1;
    register_filled = 0;
	final_file = fopen("Final.txt", "w");
    if(yyparse()==1)
	{
		printf("Parsing failed\n");
	}
	else
	{
		printf("Parsing completed successfully\n");
        generate_code(ast_root);
	}

	fclose(final_file);
    // printf("Printing IC:\n\n");
	// system("cat Final.txt");
    printf("\n\n");
    return(0);
}

int generate_code(ASTNode *root)
{
    if(root->type == 1)
    {       
        if(strcmp(root->ope, "PRINT") == 0)
        {
            // fprintf(final_file, "PRINT ");
            // if (root->child[0]->child[0]->type == 2)
            // {
            //     fprintf(final_file, "%s\n", root->child[0]->child[0]->id);
            // }
            // else if(root->child[0]->child[0]->type == 3)
            // {
            //     fprintf(final_file, "%d\n", root->child[0]->child[0]->num_value);
            // }
            // else
            // {
            //     fprintf(final_file, "%s\n", root->child[0]->child[0]->str_value);
            // }
        }
        else if(strcmp(root->ope, "EQ_DT") == 0)
        {
            char *lhs_id = (char *)malloc(sizeof(char)*50);
            strcpy(lhs_id, root->child[0]->child[0]->id);
            int lhs_reg_id = get_register_value(lhs_id, 0);
            generate_code_operations(root->child[1], lhs_reg_id);
        }
        else if(strcmp(root->ope, "EQ_OPR") == 0)
        {
            char *lhs_id = (char *)malloc(sizeof(char)*50);
            strcpy(lhs_id, root->child[0]->child[0]->id);
            int lhs_reg_id = get_register_value(lhs_id, 0);
            generate_code_operations(root->child[1], lhs_reg_id);
        }
        else if(strcmp(root->ope, "EQ_STR") == 0)
        {
            char *lhs_id = (char *)malloc(sizeof(char)*50);
            strcpy(lhs_id, root->child[0]->child[0]->id);
            int lhs_reg_id = get_register_value(lhs_id, 0);
            // fprintf(final_file, "MOV R%d, %s\n", lhs_reg_id, root->child[1]->child[0]->str_value);
        }
        else if(strcmp(root->ope, "EQ_N_DT") == 0)
        {
            char *lhs_id = (char *)malloc(sizeof(char)*50);
            strcpy(lhs_id, root->child[0]->child[0]->id);
            int lhs_reg_id = get_register_value(lhs_id, 0);
            int op1_reg_id = -1;
            int op1_value = 0;
            if (root->child[1]->child[0]->type == 2)
            {
                char *op1_id = (char *)malloc(sizeof(char)*50);
                strcpy(op1_id, root->child[1]->child[0]->id);
                op1_reg_id = get_register_value(op1_id, 1);
            }
            else
            {
                op1_value = root->child[1]->child[0]->num_value;
            }
            fprintf(final_file, "NOR R%d, ", lhs_reg_id);
            if (root->child[1]->child[0]->type == 2)
            {
                fprintf(final_file, "R%d, R%d\n", op1_reg_id, op1_reg_id);
            }
            else
            {
                fprintf(final_file, "#%d, #%d\n", op1_value, op1_value);
            }
        }
        else if(strcmp(root->ope, "GOTO" ) == 0)
        {
            fprintf(final_file, "B %s\n", root->child[0]->child[0]->id);
        }
        else if(strcmp(root->ope, "IF_GOTO") == 0)
        {
            char *lhs_id = (char *)malloc(sizeof(char)*50);
            strcpy(lhs_id, root->child[0]->child[0]->id);
            int lhs_reg_id = get_register_value(lhs_id, 0);
            fprintf(final_file, "BNEZ R%d, %s\n", lhs_reg_id, root->child[1]->child[0]->id);
        }
        else if(strcmp(root->ope, "BRANCH") == 0)
        {
            fprintf(final_file, "%s :\n", root->child[0]->child[0]->id);
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

int generate_code_operations(ASTNode *root, int register_value)
{
    if(root->type == 1)
    {
        if(strcmp(root->ope, "+") == 0 || strcmp(root->ope, "-") == 0 || strcmp(root->ope, "*") == 0 || strcmp(root->ope, "/") == 0 || strcmp(root->ope, "MOD") == 0 || strcmp(root->ope, "AND") == 0 || strcmp(root->ope, "OR") == 0)
        {
            int op1_reg_id = -1;
            int op2_reg_id = -1;
            int op1_value = 0;
            int op2_value = 0;
            if (root->child[0]->child[0]->type == 2)
            {
                char *op1_id = (char *)malloc(sizeof(char)*50);
                strcpy(op1_id, root->child[0]->child[0]->id);
                op1_reg_id = get_register_value(op1_id, 1);
            }
            else
            {
                op1_value = root->child[0]->child[0]->num_value;
            }
            if (root->child[1]->child[0]->type == 2)
            {
                char *op2_id = (char *)malloc(sizeof(char)*50);
                strcpy(op2_id, root->child[1]->child[0]->id);
                op2_reg_id = get_register_value(op2_id, 1);
            }
            else
            {
                op2_value = root->child[1]->child[0]->num_value;
            }

            if(strcmp(root->ope, "+") == 0)
            {
                fprintf(final_file, "ADD ");
            }
            else if(strcmp(root->ope, "-") == 0)
            {
                fprintf(final_file, "SUB ");
            }
            else if(strcmp(root->ope, "*") == 0)
            {
                fprintf(final_file, "MUL ");
            }
            else if(strcmp(root->ope, "/") == 0)
            {
                fprintf(final_file, "DIV ");
            }
            else if(strcmp(root->ope, "MOD") == 0)
            {
                fprintf(final_file, "MOD ");
            }
            else if(strcmp(root->ope, "AND") == 0)
            {
                fprintf(final_file, "AND ");
            }
            else if(strcmp(root->ope, "OR") == 0)
            {
                fprintf(final_file, "OR ");
            }
            fprintf(final_file, "R%d, ", register_value);

            if (root->child[0]->child[0]->type == 2)
            {
                fprintf(final_file, "R%d, ", op1_reg_id);
            }
            else
            {
                fprintf(final_file, "#%d, ", op1_value);
            }
            if (root->child[1]->child[0]->type == 2)
            {
                fprintf(final_file, "R%d\n", op2_reg_id);
            }
            else
            {
                fprintf(final_file, "#%d\n", op2_value);
            }
        }
        else if(strcmp(root->ope, "NUMBER") == 0 || strcmp(root->ope, "ID") == 0)
        {
            int op1_reg_id = -1;
            int op1_value = 0;
            if (root->child[0]->type == 2)
            {
                char *op1_id = (char *)malloc(sizeof(char)*50);
                strcpy(op1_id, root->child[0]->id);
                op1_reg_id = get_register_value(op1_id, 1);
            }
            else
            {
                op1_value = root->child[0]->num_value;
            }
            fprintf(final_file, "MOV R%d, ", register_value);
            if (root->child[0]->type == 2)
            {
                fprintf(final_file, "R%d\n", op1_reg_id);
            }
            else
            {
                fprintf(final_file, "#%d\n", op1_value);
            }
        }
        else
        {
            int op1_reg_id = -1;
            int op2_reg_id = -1;
            int op1_value = 0;
            int op2_value = 0;
            char *temp_name = (char *)malloc(sizeof(char)*10);
            strcpy(temp_name, "$result");
            int result_reg = get_register_value(temp_name, 0);
            if (root->child[0]->child[0]->type == 2)
            {
                char *op1_id = (char *)malloc(sizeof(char)*50);
                strcpy(op1_id, root->child[0]->child[0]->id);
                op1_reg_id = get_register_value(op1_id, 1);
            }
            else
            {
                op1_value = root->child[0]->child[0]->num_value;
            }
            if (root->child[1]->child[0]->type == 2)
            {
                char *op2_id = (char *)malloc(sizeof(char)*50);
                strcpy(op2_id, root->child[1]->child[0]->id);
                op2_reg_id = get_register_value(op2_id, 1);
            }
            else
            {
                op2_value = root->child[1]->child[0]->num_value;
            }

            fprintf(final_file, "SUB R%d, ", result_reg);

            if (root->child[0]->child[0]->type == 2)
            {
                fprintf(final_file, "R%d, ", op1_reg_id);
            }
            else
            {
                fprintf(final_file, "#%d, ", op1_value);
            }
            if (root->child[1]->child[0]->type == 2)
            {
                fprintf(final_file, "R%d\n", op2_reg_id);
            }
            else
            {
                fprintf(final_file, "#%d\n", op2_value);
            }
            int if_branch = ++as_branch_number;
            int exit_branch = ++as_exit_number;

            if(strcmp(root->ope, "EQUAL_TO") == 0)
            {
                fprintf(final_file, "BEQZ R%d ASL%d\n", result_reg, if_branch);
            }
            else if(strcmp(root->ope, "<") == 0)
            {
                fprintf(final_file, "BLTZ R%d ASL%d\n", result_reg, if_branch);
            }
            else if(strcmp(root->ope, ">") == 0)
            {
                fprintf(final_file, "BGTZ R%d ASL%d\n", result_reg, if_branch);
            }
            fprintf(final_file, "MOV R%d #0\n", register_value);
            fprintf(final_file, "B ASEXIT%d\n", exit_branch);
            fprintf(final_file, "ASL%d :\n", if_branch);
            fprintf(final_file, "MOV R%d #1\n", register_value);
            fprintf(final_file, "ASEXIT%d :\n", exit_branch);
        }
    }
    return 0;
}

int get_register_value(char *id, int is_rhs)
{
    for(int i=0; i<USE; i++)
    {
        if(strcmp(id, register_queue[i])==0)
        {
            return i;
        }
    }
    register_front = (register_front+1) % USE;
    if(register_filled == 13)
    {
        fprintf(final_file, "STR R%d, %s\n", register_front, register_queue[register_front]);
    }
    else
    {
        register_filled += 1;
    }
    strcpy(register_queue[register_front], id);
    if(is_rhs)
    {
        fprintf(final_file, "LOAD R%d, %s\n", register_front, register_queue[register_front]);
        // printf("MOV %s, R%d\n", register_queue[register_front], register_front);
    }
    return register_front;
}
