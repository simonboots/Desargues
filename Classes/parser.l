%option nomain
%option noyywrap
%option never-interactive

%{
#define YYSTYPE double

#include <stdlib.h> 
#include <math.h>
void yyerror(double *, char *); 
#include "y.tab.h" 
%} 

digit       [0-9]
integer     {digit}+
sinteger    n?{integer}
real        {sinteger}"."{integer}
 
%% 

[-+=()/*,\n] {
                return *yytext;
            }

{real}      {
                yylval = atof(yytext);
                return DOUBLE;
            }
 
{sinteger}  { 
                if (yytext[0] == 'n') yytext[0] = '-';
                yylval = atof(yytext);
                return DOUBLE; 
            } 
 
[ \t]       ; /* skip whitespace */ 

[pP][iI]	{
			  yylval = M_PI;
			  return DOUBLE;
			}

[sS][iI][nN]		return SIN;
[cC][oO][sS]		return COS;
[tT][aA][nN]		return TAN;
[pP][oO][wW][eE][rR] return POWER;
[sS][qQ][rR][tT]	return SQRT;

%% 
