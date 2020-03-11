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
        int type;
        /*
            0 - NULL value
            1 - operator - for/while/if/+/-/*.....
            2 - id
            3 - number value
            4 - bool value
            5 - string value
        */
		char operator[16];
		char id[100];
		int num_value;
        char bool_value;
        char *str_value;
	}Node;
    Node *root;
    Node *node_stack[1024];
    int stack_top;

	// typedef struct tree_stack{
	// 	Node *node;
	// 	struct tree_stack *next;
	// }tree_stack;
    // void create_node(char *token, int leaf);
	// void push_tree(Node *newnode);
	// Node *pop_tree();
	// void preorder(Node* root);
	// void printtree(Node* root);
	// int getmaxlevel(Node *root);
	// void printGivenLevel(Node* root, int level, int h);
	// void get_levels(Node *root, int level);

%}
%union {
    int intVal;
    bool boolVal;
    char* id;
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
%token<id> _id _str
%token _print _setq _if _loopfor _loopwhile _do _in _from _to

%left '>' '<' '='
%left '+' '-' 
%left '*' '/' _mod 
%left _and _or _not
%left '(' ')' 

%%
PROGRAM             : STMT STMTS 
                    ;
STMTS               : STMT STMTS 
                    | 
                    ;
STMT                : EXP 
                    | SET_STMT 
                    | PRINT_STMT 
                    | LOOPFOR_EXP 
                    | LOOPWHILE_EXP 
                    ;
    
PRINT_STMT          : '(' _print EXP ')' 
                    ;
EXPS                : EXP EXPS 
                    | 
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
                    |
                    ;
LISTELEM_STR        : _str LISTELEM_STR
                    |
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
		printf("\nParsing failed\n");
	}
	else
	{
		printf("\nParsing completed successfully\n");
	}
    display();
    return(0);
}

// void create_node(char *token, int leaf) {
// 	Node *l;
// 	Node *r;
// 	if(leaf==0) {

// 		r = pop_tree();
// 		l = pop_tree();  		//returns NULL if it doesnt exist
// 	}
// 	else if(leaf ==1) {
// 		l = NULL;
// 		r = NULL;
// 	}
// 	else {
// 		l = pop_tree();
// 		r = NULL;
// 	}

// 	Node *newnode = (Node*)malloc(sizeof(Node));
// 	strcpy(newnode->token, token);
// 	newnode->left = l;
// 	newnode->right = r;
// 	push_tree(newnode);
// }


// void push_tree(Node *newnode){
// 	tree_stack *temp= (tree_stack*)malloc(sizeof(tree_stack));
// 	temp->node = newnode;
// 	temp->next = tree_top;
// 	tree_top = temp;
// }


// Node* pop_tree(){
// 	tree_stack *temp = tree_top;
// 	tree_top = tree_top->next;
// 	Node *retnode = temp->node;
// 	if(temp != NULL)
// 		free(temp);
// 	return retnode;
// }


// void printtree(Node* root){
//     int h = getmaxlevel(root)-1;
//     int i;

  
// 	fprintf(fp_ast, "\n\nAbstract Syntax Tree\n\n");

//     for (i=1; i<=h; i++){
// 		fprintf(fp_ast, "\t");
// 		for(int j=0;j<=h+1-i;j++){
// 			fprintf(fp_ast, "      ");
// 		}
//         printGivenLevel(root, i,h);
//         fprintf(fp_ast, "\n\n");
//     }
// }


// int getmaxlevel(Node *root){
// 	int count=0;
// 	Node *temp= root;
// 	while(temp->left!=NULL){
// 		count++;
// 		temp=temp->left;
// 	}
// 	return count*2;
// }


// void printGivenLevel(Node* root, int level, int h){
//     if (root == NULL)
//         return;
//     if (level == 1){
// 		for(int j=0; j<=h-1-level; j++){
// 			fprintf(fp_ast, " ");
// 		}
// 	    fprintf(fp_ast, "%s ", root->token);
// 	}
//     else if (level > 1){
//         printGivenLevel(root->left, level-1,h);
// 		for(int j=0; j<=h-1-level; j++){
// 			fprintf(fp_ast, " ");
// 		}
//         printGivenLevel(root->right, level-1,h);
//     }
// }


// void preorder(Node * node){
// 	if (node == NULL)
// 		return;

// 	if(node->left!=NULL && node->right!=NULL)
// 		strcat(preBuf, "   ( ");
// 	strcat(preBuf, node->token);
// 	strcat(preBuf, "   ");

// 	preorder(node-> left);

	
// 	if(node->right){
// 		preorder(node-> right);
// 	}
	
// 	if(node->left!=NULL && node->right!=NULL)
// 		strcat(preBuf, ")   ");
// 	// printf("\n");
	
// }

// void get_levels(Node *root, int level){
// 	root->level = level;
// 	if(root->left == NULL && root->right == NULL){
// 		return;
// 	}
// 	if(root->left == NULL){
// 		get_levels(root->right, level+1);
// 	}
// 	else if(root->right == NULL){
// 		get_levels(root->left, level+1);
// 	}
// 	else{
// 		get_levels(root->left, level+1);
// 		get_levels(root->right, level+1);
// 	}
// }
