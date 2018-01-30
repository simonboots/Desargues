%{
#define YYSTYPE double

#include <stdio.h>
#include <math.h>
#include <strings.h>
	
int yylex(void); 
void yyerror(double *, char *); 
%} 

%parse-param {double *result}

%token DOUBLE, SIN, COS, TAN, POWER, SQRT

%left '+' '-'
%left '*' '/'

%% 
 
program: 
        program expr              { *result = floor($2 * 1000)/1000; } 
        |  
        ; 
 
expr:
        DOUBLE							{ $$ = $1; }
        | expr '+' expr					{ $$ = $1 + $3; } 
        | expr '-' expr					{ $$ = $1 - $3; } 
        | expr '*' expr					{ $$ = $1 * $3; } 
        | expr '/' expr					{ $$ = $1 / $3; } 
        | '(' expr ')'					{ $$ = $2; }
		| SIN '(' expr ')'				{ $$ = sin ($3); }
		| COS '(' expr ')'				{ $$ = cos ($3); }
		| TAN '(' expr ')'				{ $$ = tan ($3); }
		| POWER '(' expr ',' expr ')'	{ $$ = pow ($3, $5); }
		| SQRT '(' expr ')'				{ $$ = sqrt($3); }
        ; 
 
%% 
 
void yyerror(double *result, char *s) { 
    fprintf(stderr, "%s\n", s); 
}
