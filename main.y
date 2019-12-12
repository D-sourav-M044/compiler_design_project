%{
	#include <stdio.h>
	#include <math.h>
	#include<stdlib.h>
	#include<string.h>

	typedef struct sourav {
		char *name;
		double val;
	} ids;

	ids sign2[10];
	int count = 0;

	//int sign[26];

	struct sourav* check(char* id);
	ids* create(char* id,double val);
	int getVal(char *id);
	int Switchval;
%}

%union {
  double DOB;   
  int IN;
  char *id;
}
%token <IN> Number
%token <DOB>  Number1    
%token <id>  Variable  
%type  <DOB>  expression 
%type  <DOB>  deal
%type  <IN>  bool_expr
%type  <IN>  Variables
%token <id>  FUNCTION

%token AR INC DEC LP RP AND OR NOT ITEAM RET DIE ELSE_IF START_BLOCK THAN ASSIGN END_BLOCK Var BOOL_EXPR_CLOSE IF ELSE Main End INT FLOAT SUM SUB MUL DIV FOR WHILE DO LT GT GTE LTE finish SINE COS TAN LN FACTORIAL WHILE TOTHEPOWER Switch Case1 Case2 Case3 Number1
%nonassoc IFX
%nonassoc ELSE
%nonassoc ASSIGN
%left AND OR NOT
%left LT GT LTE GTE
%left SINE COS TAN LN
%left SUM SUB
%left MUL DIV
%left FACTORIAL
%left TOTHEPOWER
%left INC DEC

%%

sentence: /* empty */
	| sentence deal
	| sentence catch
	;
	
catch: INT Variable finish
	{ 
		ids *a = check($2);
		if(a == NULL) {
			ids *x = create($2,0);
			printf("\nDeclared variable-> %s : %lf\n", x->name, x->val);
		}
		else {
			printf("Already Declared variable : %s !\n", $2);
		}
	}	
	| FLOAT Variable finish	{ 
		ids *a = check($2);
		if(a == NULL) {
			ids *x = create($2,0);
			printf("\nDeclared variable-> %s : %lf\n", x->name, x->val);
		}
		else {
			printf("Already Declared variable : %s !\n", $2);
		}	
	}
	| INT Variable ASSIGN Number finish
	 {
		ids *a = check($2);
		if(a == NULL) {
			ids *x = create($2,$4);
			printf("\nvariable declared %s : %.10g\n", x->name, x->val);
		}
		else {
			printf("variable is Already declared : %s !\n", $2);
		}
	}
	| FLOAT Variable ASSIGN Number1 finish {
		ids *a = check($2);
		if(a == NULL) {
			ids *x = create($2,$4);
			printf("\nvariable declared %s : %.10g\n", x->name, x->val);
		}
		else {
			printf("variable is Already declared : %s !\n", $2);
		}
	}
	;
			

deal: finish {
		printf("empty statement\n");
	}

	| Variable ASSIGN expression finish {
		ids* a = check($1);
		if(a) {
			a->val = $3;
			$$ = $3;
			printf("Updated variable's value %s : %.10g\n", $1, $3);
		}
		else {
			printf("Variable %s not declared!\n", $1);
		}
	}
    
	| expression finish { 
		$$ = $1; 
		printf("Value: %.10g\n", $1); 
	}

	| IF LP bool_expr RP STMNT_BLOCK 
	{
								if($3)
								{
									printf("if part is true\n");
								}
								else
								{
									printf("if part is false\n");
								}
							}
	
	| IF LP bool_expr RP STMNT_BLOCK ELSE STMNT_BLOCK {
								 	if($3)
									{
										printf("if part is true\n");
									}
									else
									{
										printf("if part is false\n");
									}
								   }


	| IF LP bool_expr RP STMNT_BLOCK ELSE_IF_BLOCK ELSE STMNT_BLOCK {
		if($3) {
			printf("if part is true\n");
		}
		else {
			printf("if part is false\n");

		}
	}
	|Variable INC finish
	{
		ids *a = check($1);
		if(a==NULL)
		printf("%s is not initialized",a);
		else
		printf("%s is increased",a->name);	
	}
	|Variable DEC finish
	{
		ids *a = check($1);
		if(a==NULL)
		printf("%s is not initialized",a);
		else
		printf("%s is decreased",a->name);	
	}
	| WHILE LP Variable LTE Number RP STMNT_BLOCK {
		ids *a = check($3);
		if(a == NULL) {
			a = malloc(sizeof(ids));
		}
		int start =getVal($3);
		int end = $5;
		for(a->val = start; a->val <= end; a->val+=1)
			printf("while : value of %s = %d\n", $3, (int)a->val);
	}
	| FOR LP Variable ASSIGN expression finish Variable LTE expression finish Variable INC RP STMNT_BLOCK {
		ids *a = check($3);
		if(a == NULL) {
			a = malloc(sizeof(ids));
		}
		int start = (int)$5;
		int end = (int)$9;
		
		for(a->val = start; a->val <= end; a->val+=1)
			printf("FOR : value of %s = %d\n", $3, (int)a->val);
		
	}
	
	| Switch LP Variable RP {
		ids *a = check($3);
		if(a) {
			printf("Successful Switch Statement with \n\tvariable %s\n\tcase : %d\n", $3, (int)(a->val));
			Switchval = a->val;
		}
		else {
			printf("Variable %s is  not declared!\n", $3);
		}
	} Cases

	| FUNCTION LP Variables RP PROGRAM {
		printf("Successfully created function : %s with %d variables\n", $1, $3);
	}
	|expression AND expression finish
	{
		printf("AND executed\n");
	}
	|expression OR expression finish
	{
		printf("OR executed\n");
	}
	|expression NOT finish
	{
		printf("NOT executed\n");
	}
	;

PROGRAM: START_BLOCK sentence RET_STMNT END_BLOCK {

}
;

RET_STMNT: RET expression finish ;

Variables : Variable { $$ = 1; }
	| Variable AR Variables { $$ = 1 + $3; }
	;
Cases: /*empty*/
	| Case Cases
	;
Case: ITEAM Number STMNT_BLOCK {
	if($2==Switchval){
		printf("Case mATCHED\n");
	}
	if($2) {
		printf("Case %d is done\n", (int)$2);
	}

}

ELSE_IF_BLOCK:  /* NULL */
	| ELSE_IF LP bool_expr RP STMNT_BLOCK ELSE_IF_BLOCK 
	{
		if($3) {
			printf("Expression in else if is : true\n");
		}
		else {
			printf("Expression in else if is : false\n");

		}
	}

STMNT_BLOCK: START_BLOCK sentence END_BLOCK {
	printf("Successfully executed\n");
 }

expression: Number{
	$$ = $1; printf("value is: %d\n",$1); 	
	}	
	| LP expression RP { $$ = $2; }
	| Variable			{
		ids *a = check($1);
		if(a) {
			$$ = a->val;
		}
		else {
			$$ = 0 ;
			printf("Variable not declared!\n");
		}
	}
	|Number1{
	$$ = $1; 
	}	

	| expression SUM expression	   { $$ = $1 + $3; }

	| expression SUB expression	   { $$ = $1 - $3; }

	| expression MUL expression	   { $$ = $1 * $3; }

	| expression DIV expression	   { 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}

						
	| expression SINE { $$=sin($1 * 3.1416/ 180); printf(" sin value %.10g\n",$$); }
	| expression COS { $$=cos($1 *3.1416 / 180); printf(" cos value %.10g\n",$$); }
	| expression  TAN { $$=tan($1 *3.1416/ 180); printf(" tan value %.10g\n",$$); }
	| expression LN { $$=log($1); printf(" ln value %.10g\n",$$); }	
    | expression FACTORIAL {
						int mult=1 ,i;
						for(i=$1;i>0;i--)
						{
							mult=mult*i;
						}
						$$=mult;
						printf("factorial value is %.10g\n",$$); 
					 }	
					 
	| expression TOTHEPOWER expression { $$=pow($1,$3); printf("To the power value %.10g\n",$$); }				 
	
        ;
bool_expr:
|expression 
	{
		$$=1;
		//printf("paichi");
	}
| expression GT expression {
	$$ = $1 > $3;
	printf("bool_expr [>]: %d\n", $$);
}

	| expression LT expression {
	$$ = $1 < $3;
	printf("bool_expr [<]: %d\n", $$);
}
	| expression GTE expression {
	$$ = $1 >= $3;
	printf("bool_expr [>=]: %d\n", $$);
}
	| expression LTE expression {
	$$ = $1 <= $3;
	printf("bool_expr [<=]: %d\n", $$);
}
	| bool_expr AND bool_expr {
		$$ = $1 && $3;
	printf("bool_expr AND: %d\n", $$);
	}
	| bool_expr OR bool_expr {
		$$ = $1 && $3;
	printf("bool_expr OR: %d\n", $$);
	}
	| NOT bool_expr {
		$$ = !($2);
	printf("bool_expr NOT: %d\n", $$);
	}
	| LP bool_expr RP { $$ = $2;
			printf("bool_expr bracket: %d\n", $$);
	}

%%

struct sourav *check(char* id) {
	for(int i = 0; i<count; i++) {
		if(strcmp(sign2[i].name, id) == 0) {
			return sign2+i;
		}
	}
	return NULL;
}
int getVal(char *id){
	ids *a = check(id);
	if(a==NULL){
		printf("Varriable is  not declared\n");
		exit(-1);
	}
	return a->val;
}
ids* create(char* id,double maan) {
	printf("value is :%lf",maan);
	ids *val = malloc(sizeof(ids));
	char *name = malloc(sizeof(char)*strlen(id));
	strcpy(name, id);
	val->name = name;
	val->val = (double) maan;
	sign2[count++] = *val;
	return val;
}

int yywrap()
{
return 1;
}

yyerror(char *s){
	printf( "%s\n", s);
}
