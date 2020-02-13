%{
    #include <string.h>
    #include "y.tab.h"
    extern "C" {
        int yylex();
    }
    int scope_var;
    int table_pointer;
    char* ERROR_TOKEN;
	void insert(char *id, int line_no, int scope);
	void display();
%}
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|"-")*
bool-val   T|F

%%
<<EOF>>                     { return 0; }
{separator}                 { ; }
"+"                         { return(yytext[0]); }
"-"                         { return(yytext[0]); }
"*"                         { return(yytext[0]); }
"/"                         { return(yytext[0]); }
">"                         { return(yytext[0]); }
"<"                         { return(yytext[0]); }
"="                         { return(yytext[0]); }
"("                         { scope_var++ ; return(yytext[0]); }
")"                         { scope_var-- ; return(yytext[0]); }
"mod"                       { return(_mod); }
"and"                       { return(_and); }
"or"                        { return(_or); }
"not"                       { return(_not); }
"setq"                      { return(_setq); }
"if"                        { return(_if); }
"loop for"                  { return(_loopfor); }
"loop while"                { return(_loopwhile); }
"in"                        { return(_in); }
"to"                        { return(_to); }
"from"                      { return(_from); }
"print"                     { return(_print); }
{number}                    { sscanf(yytext, "%d", &yylval.intVal); return(_number); }
{bool-val}                  { if(yytext[0] == 'T') yylval.boolVal = true; else yylval.boolVal = false; return(_bool_val); }
\"({letter}|{digit})*\"     { return(_str); }
{id}                        { printf("%s\n", yytext); insert(yytext, yylineno, scope_var-1); return(_id); }
.                           { return yytext[0]; }
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
void insert(char *id, int line_no, int scope)
{
    strcpy(symtab[table_pointer].id,id);
    symtab[table_pointer].line_no = line_no;
    symtab[table_pointer].scope = scope;
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


int yywrap()
{
    return(1);
}
