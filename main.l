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
int line = 0;
int punc = 0;


%}
IDENTIFIER [a-zA-Z][a-zA-Z0-9]*[_]?[a-zA-Z0-9]*
DIGIT [0-9]

%%
"<<" {
	punc++;
	return START_BLOCK;
}
">>" {
	punc++;
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
	keywords++;
	ints++;
	return INT; 
	}

"broken"	     { 
	keywords++;
	floats++;
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
	return IF; }


"otherwise"    { keywords++; return ELSE; }

"un" {keywords++; return WHILE;}
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
	keywords++;
	return RET;
}


"func_"{IDENTIFIER}+ {
	char * p;
	p=(char *) calloc(strlen(yytext)+1, sizeof(char));
	strcpy(p,yytext);
	yylval.id = p;
	function_calls++;
	return FUNCTION;
	
}

{IDENTIFIER} {
			printf("variable : %s\n", yytext);
			char * p;
			p=(char *) calloc(strlen(yytext)+1, sizeof(char));
			strcpy(p,yytext);
			yylval.id = p;
			ids++;
			return Variable;
		}

"-"?{DIGIT}+ {
	yylval.DOB=atof(yytext);
	return Number;
	}

"-"?{DIGIT}+?"."{DIGIT}+ {
	yylval.DOB=atof(yytext);
	return Number;
	}
"@@".*          { printf("single line comment\n"); }
"@*"[^*@]*"*@"      { 
	printf("multipleline comment\n");
	 }
[ ]*	{sp++;}
[\t]*	{line++; printf("\t\t\t\t\t line %d executed\n ",line);}
[\n]* 	{line++; printf("\t\t\t\t\t line %d executed\n ",line);}
	
%%


int main()
{
	yyin = freopen("in.txt","r",stdin);
	yyout = freopen("out.txt","w",stdout);
	yyparse();

	fclose(yyin);
	printf("\n\n\t\t\t\t\t{final analysis}\n");
	printf("NO of Punctuations is : %d\n", punc);
	printf("No of total variable is : %d\n", ids);
    printf("NO of Operators  : %d\n", ops);
	printf("No of Function : %d\n", function_calls);
    printf("No of round variable : %d\n", ints);
	printf("No of Keywords : %d\n", keywords);
    printf("NO of broken variable : %d\n", floats);
	printf("NO of Spaces : %d\n", sp);
    printf("NO of Newlines : %d\n", line);
	printf("\t\t\t\t\tprogram finished");

	return 0;
    
}
