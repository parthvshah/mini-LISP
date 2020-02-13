%{
    // #include "ASTTree.hh"
    #include "y.tab.h"
    extern "C" {
        int yylex();
    }
%}
separator  [ \t\n\r]
letter     [a-z]
digit      [0-9]
number     0|[1-9]{digit}*|-[1-9]{digit}*
id         {letter}({letter}|{digit}|"-")*
bool-val   T|F

%%
<<EOF>>         { return 0; }
{separator}     { ; }
"+"             { return(yytext[0]); }
"-"             { return(yytext[0]); }
"*"             { return(yytext[0]); }
"/"             { return(yytext[0]); }
">"             { return(yytext[0]); }
"<"             { return(yytext[0]); }
"="             { return(yytext[0]); }
"mod"           { return(_mod); }
"and"           { return(_and); }
"or"            { return(_or); }
"not"           { return(_not); }
"setq"          { return(_setq); }
"if"            { return(_if); }
"loop for"      { return(_if); }
"loop"          { return(_if); }
"do"            { return(_if); }
"in"            { return(_if); }
"from"          { return(_if); }
"print"         { return(_print); }
{number}        { sscanf(yytext, "%d", &yylval.intVal); return(_number); }
{bool-val}      { if(yytext[0] == 'T') yylval.boolVal = true; else yylval.boolVal = false; return(_bool_val); }
{id}            { yylval.id = strdup(yytext); return(_id); }
.               { return(yytext[0]); }
%%
