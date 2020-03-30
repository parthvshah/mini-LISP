%{
    #include <string.h>
    #include "ASTTree.hh"
    #include "y.tab.h"
    extern "C" {
        int yylex();
    }
    int table_pointer;
    int line_number;
    int setting_value;
    int currHighest = 0;
    int top = 0;
    int my_stack[256];
    int loop = 1;
    char* ERROR_TOKEN;
	void insert(char *id);
	void display();
    void push();
    int pop();
    int get_top();
    void set_num(char *value);
    void set_bool(char *value);
    void set_str(char *value);

    char *last_id;
    char *last_str;
    char last_bool;
    int last_num;
%}
separator  [ \t\n\r]
letter     [a-zA-Z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|"-")*
bool-val   T|F

%%
<<EOF>>                     { return 0; }
"\n"                        { line_number++; }
{separator}                 { ; }
"+"                         { return(yytext[0]); }
"-"                         { return(yytext[0]); }
"*"                         { return(yytext[0]); }
"/"                         { return(yytext[0]); }
">"                         { return(yytext[0]); }
"<"                         { return(yytext[0]); }
"="                         { return(yytext[0]); }
"'"                         { return(yytext[0]); }
"("                         {   
                                setting_value = 0 ;
                                loop = 0;
                                return(yytext[0]);
                            }
")"                         {
                                int return_value;
                                if(loop)
                                {
                                    return_value = pop();
                                }   
                                loop = 1;
                                if(return_value == -1)
                                {
                                    insert(ERROR_TOKEN);
                                }
                                else
                                {
                                    return(yytext[0]);
                                }
                            }
"mod"                       { return(_mod); }
"and"                       { return(_and); }
"or"                        { return(_or); }
"not"                       { return(_not); }
"setq"                      { setting_value = 1 ; return(_setq); }
"if"                        { push() ; return(_if); }
"loop for"                  { push() ; return(_loopfor); }
"loop while"                { push() ; return(_loopwhile); }
"in"                        { return(_in); }
"to"                        { return(_to); }
"from"                      { return(_from); }
"print"                     { return(_print); }
{number}                    { sscanf(yytext, "%d", &yylval.intVal) ; set_num(yytext) ; setting_value = 0 ; return(_number); }
{bool-val}                  { yylval.id = strdup(yytext) ; set_bool(yytext) ; setting_value = 0 ; if(yytext[1] == 't') yylval.boolVal = true; else yylval.boolVal = false ; return(_bool_val); }
\"({letter}|" "|{digit})*\" { yylval.str = strdup(yytext) ; set_str(yytext) ; setting_value = 0 ;  return(_str); }
{id}                        { 
                                setting_value = 0;
                                if(loop == 0)
                                {
                                    yylval.id = strdup(yytext);
                                    insert(yytext);
                                    return(_id);
                                }
                                else
                                {
                                    insert(ERROR_TOKEN);
                                }
                            }
"#".*                       { ; }
.                           { printf("%s\n", yytext); insert(ERROR_TOKEN); }
%%

struct row
{
	char id[128];
	int line_no;
	int scope;
    int valid_value;
    int num_value;
    char bool_value;
    char *str_value;
    int type;
};

struct row symtab[100];
// increment table_pointer after every insertion
//insert into syntab[table_pointer]
void insert(char *id)
{
    strcpy(symtab[table_pointer].id,id);
    symtab[table_pointer].line_no = line_number;
    symtab[table_pointer].scope = get_top();
    symtab[table_pointer].valid_value = 0;
    symtab[table_pointer].type = 0;
    table_pointer++;
}

void set_num(char *value)
{
    symtab[table_pointer-1].valid_value = 1;
    symtab[table_pointer-1].type = 1;
    symtab[table_pointer-1].num_value = atoi(value);
}

void set_bool(char *value)
{
    symtab[table_pointer-1].valid_value = 1;
    symtab[table_pointer-1].type = 2;
    symtab[table_pointer-1].bool_value = value[0];
}

void set_str(char *value)
{
    symtab[table_pointer-1].valid_value = 1;
    symtab[table_pointer-1].type = 3;
    symtab[table_pointer-1].str_value = new char[strlen(value)+1];
    strcpy(symtab[table_pointer-1].str_value, value);

}

void display()
{
    for(int i=0 ; i<table_pointer ; i++)
    {
        printf("Id    : %s\n", symtab[i].id);
        printf("line  : %d\n", symtab[i].line_no);
        printf("scope : %d\n", symtab[i].scope);
        if(symtab[i].valid_value)
        {
            switch(symtab[i].type)
            {
                case 1: 
                        printf("type : %s\n", "NUM");
                        printf("value : %d\n", symtab[i].num_value);
                        break;
                case 2: 
                        printf("type : %s\n", "BOOL");
                        printf("value : %c\n", symtab[i].bool_value);
                        break;
                case 3: 
                        printf("type : %s\n", "STRING");
                        printf("value : %s\n", symtab[i].str_value);
                        break;
            }
        }
        printf("\n");
    } 
    printf("\n\n");
}

void push()
{
    my_stack[++top] = ++currHighest;
}   

int pop()
{
    if(top == 0)
        return -1;
    top--;
    return 0;
}

int get_top()
{
    return my_stack[top];
}


int yywrap()
{
    return(1);
}
