%{
	#define YYSTYPE char*
	#include "y.tab.h"
    #include <stdio.h>
    extern void yyerror(const char *);
    int line = 1;
%}

Digit   		[0-9]
Letter   		[a-zA-Z_]
Character   	[a-zA-Z_0-9]
WhiteSpace  	[  \t\v\f]

%%

[\n]				    {line++;}
"||"				    {yylval = strdup(yytext);return T_OR_OP;} 
"&&"				    {yylval = strdup(yytext);return T_AND_OP;} 
"=" 				    {yylval = strdup(yytext);return T_EQ_OP;} 
"!" 				    {yylval = strdup(yytext);return T_NE_OP;} 
"<"		    		    {yylval = strdup(yytext);return T_LE_OP;} 
">"	    			    {yylval = strdup(yytext);return T_GE_OP;} 
"="	    			    {yylval = strdup(yytext);return T_AS_OP;}	

"+"					    {yylval = strdup(yytext);return('+'); }
"-"					    {yylval = strdup(yytext);return('-'); }
"*"					    {yylval = strdup(yytext);return('*'); }
"/"					    {yylval = strdup(yytext);return('/'); }
"%"		    		    {yylval = strdup(yytext);return T_MOD_OP;}
"<"					    {yylval = strdup(yytext);return('<'); }
">"					    {yylval = strdup(yytext);return('>'); }
"="					    {yylval = strdup(yytext);return('='); }

"GOTO"				    {yylval = strdup(yytext);return T_GOTO;}
"EXIT"{DIGIT}+		    {yylval = strdup(yytext);return T_IFFALSE;}
"L"{DIGIT}+				{yylval = strdup(yytext);return T_START;}
"if"				    {yylval = strdup(yytext);return T_END;}

{Digit}+	            {yylval = strdup(yytext);return T_NUMBER;} 
{Letter}{Character}*    {yylval = strdup(yytext);return T_IDENTIFIER;}
{WhiteSpace}+		    {}
.					    { printf("No Match, Invalid Expression %s\n", yytext); }

%%
