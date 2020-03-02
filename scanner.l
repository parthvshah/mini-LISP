%{
    #include <string.h>
    #include "y.tab.h"
    extern "C" {
        int yylex();
    }
    int table_pointer;
    int line_number;
    int currHighest = 0;
    int top = 0;
    int my_stack[256];
    int loop = 1;
    char* ERROR_TOKEN = "Error_Token";
	void insert(char *id);
	void display();
    void push();
    int pop();
    int get_top();
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
"setq"                      { return(_setq); }
"if"                        { push() ; return(_if); }
"loop for"                  { push() ; return(_loopfor); }
"loop while"                { push() ; return(_loopwhile); }
"in"                        { return(_in); }
"to"                        { return(_to); }
"from"                      { return(_from); }
"print"                     { return(_print); }
{number}                    { sscanf(yytext, "%d", &yylval.intVal); return(_number); }
{bool-val}                  { if(yytext[0] == 'T') yylval.boolVal = true; else yylval.boolVal = false; return(_bool_val); }
\"({letter}|{digit})*\"     { return(_str); }
{id}                        { 
                                printf("%s\n", yytext); 
                                if(loop == 0)
                                {
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
	char id[100];
	int line_no;
	int scope;
};
struct row symtab[100];
// increment table_pointer after every insertion
//insert into syntab[table_pointer]
void insert(char *id)
{
    strcpy(symtab[table_pointer].id,id);
    symtab[table_pointer].line_no = line_number;
    symtab[table_pointer].scope = get_top();
    table_pointer++;
}
void display()
{
    for(int i=0 ; i<table_pointer ; i++)
    {
        printf("Id    : %s\n", symtab[i].id);
        printf("line  : %d\n", symtab[i].line_no);
        printf("scope : %d\n", symtab[i].scope);
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
