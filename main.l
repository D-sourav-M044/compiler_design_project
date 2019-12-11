/* RE and ACTIONS */
%{

#include <stdio.h>
#include "main.tab.h"
#include<stdlib.h>
int varindex(char *var);

int keywords = 0;
int function_calls = 0;
int ids = 0;
int ops = 0;
int ints = 0;
int floats = 0;
int sp = 0;
int newline = 0;
int punc = 0;


%}

IDENTIFIER [a-zA-Z][a-zA-Z0-9]*[_]?[a-zA-Z0-9]*
DIGIT [0-9]

%%

"<<" {
	printf("%s\n",yytext);
	punc++;
	return START_BLOCK;
}
">>" {
	punc++;
	printf("%s\n",yytext);
	return END_BLOCK;
}
";" {
	punc++;
	return finish;
}

"++" {
	ops++;
	return INC;
}

"--" {
	ops++;
	return DEC;
}

"round"	     { 
	// printf("Found FullNumber type\n");
	keywords++;
	return INT; 
	}

"broken"	     { 
	// printf("Found RealNumber type\n");
	keywords++;
	return FLOAT; }
	
"switch"  { 
	keywords++;
	return Switch; }


"=" {
	ops++;
	return ASSIGN;
}

"ar" {
	punc++;
	return AR;
}


"(" {
	punc++;
	return LP;
}
")" {
	punc++;
	return RP;
}

"iteam" {
	keywords++;
	return ITEAM;
}

"elif" {
	keywords++;
	return ELSE_IF;
}	
"if"      { 
	// printf("lex : Found if\n"); 
	keywords++;
	return JODI; }


"otherwise"    { keywords++; return ELSE; }


"loop"  { keywords++; return FOR; }

"+"        { ops++; return SUM; }

"-"        { ops++; return SUB; }

"*"        { ops++; return MUL; }

"/"        { ops++; return DIV; }

">"       { ops++; return GT; }

"<"       { ops++; return LT; }

">="     { ops++; return GTE; }
"<="      { ops++; return LTE; }

"&&" { ops++; return AND; }
"||" { ops++; return OR; }
"!" { ops++; return NOT; }

"sine"    { ops++; return SINE; }
"cos"    { ops++; return COS; }
"tan"    { ops++; return TAN; }
"ln"    { ops++; return LN; }
"fact" { ops++; return FACTORIAL; }
"pow" { ops++; return TOTHEPOWER; }

"return" {
	return RET;
}


"func_"{IDENTIFIER}+ {
	char * p;
	p=(char *) calloc(strlen(yytext)+1, sizeof(char));
	strcpy(p,yytext);
	yylval.id = p;
	function_calls++;
	//printf("lex : Found Identifier Function : %s\n", yytext);
	return FUNCTION;
	
}

{IDENTIFIER} {
			printf("Found Identifier : %s\n", yytext);
			char * p;
			p=(char *) calloc(strlen(yytext)+1, sizeof(char));
			strcpy(p,yytext);
			yylval.id = p;
			//printf("lex : Found Identifier : %s\n", yytext);
			ids++;
			return Variable;
		}

"-"?{DIGIT}+ {
	yylval.DOB=atof(yytext);
	// printf("Fount number : %lf\n", yylval.DOB);
	ints++;
	return Number;
	}

"-"?{DIGIT}+?"."{DIGIT}+ {
	yylval.DOB=atof(yytext);
	// printf("Fount number : %lf\n", yylval.DOB);
	floats++;
	return Number;
	}

\/\/.* {
	//comments
}

[ ]*	{sp++;}
[\t]*	{newline++;}
[\n]* 	{newline++;}
	
%%


int main()
{
	yyin = freopen("in.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();

	fclose(yyin);
	
	printf("\n\nTotal Keywords is : %d\n", keywords);
    
	printf("Total Function_calls is : %d\n", function_calls);
   
	printf("Total Identifiers is : %d\n", ids);
    
	printf("Total Operators is : %d\n", ops);
    
	printf("Total Integers is : %d\n", ints);
    
	printf("Total Floats is : %d\n", floats);
    
	printf("Total Spaces is : %d\n", sp);
    
	printf("Total Newlines is : %d\n", newline);

	printf("Total Punctuations is : %d\n", punc);

	return 0;
    
}
