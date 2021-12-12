%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "symboltable.h"

	entry_t** symbol_table;
  entry_t** constant_table;

	double Evaluate (double lhs_value,int assign_type,double rhs_value);
	int current_dtype;
	int yyerror(char *msg);
%}

%union
{
	double dval;
	entry_t* entry;
	int ival;
}
%token <entry> IDENTIFIER

%token <dval> CONSTANT 
%token STRING


%token LESS_THEN, GREATER_THEN, LOGICAL_OR, LOGICAL_AND, LS_EQ, GR_EQ, EQ, NOT_EQ

%token MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN
%token INCREMENT DECREMENT

%token SHORT NUM VAR LONG SIGNED UNSIGNED CONSTANT

%token BEGIN END IF WHILE RETURN BREAK GOTO

%type <dval> expression
%type <dval> sub_expr
%type <dval> constant
%type <dval> unary_expr
%type <dval> arithmetic_expr
%type <dval> assignment_expr
%type <entry> lhs
%type <ival> assign_op

%begin prog

%left ','
%right '='
%left LOGICAL_OR
%left LOGICAL_AND
%left EQ NOT_EQ
%left '<' '>' LS_EQ GR_EQ
%left '+' '-'
%left '*' '/' '%'
%right '<>'


%nonassoc UMINUS
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

program: build prog|prog;

prog: vardecls| procdecls| stmtlist;

vardecls: type IDENTIFIER varlist;
varlist: id, varlist|id;

type: datatype;

datatype: sign_specifier type_specifier| type_specifier;

sign_specifier: SIGNED|UNSIGNED;

type_specifier: VAR|SHORT VAR|SHORT|LONG|LONG VAR|LONG_LONG|LONG_LONG VAR;                         

procdecls: procdecl procdecls|;
preodecl: proc id('paramlist') vardecls pstmtlist;
paramlist: type IDENTIFIER tparamlsit|;
tparamlist: param, tparamlist|param;

param: mode id;

mode: in | out | inout;

pstmtlist: pstmt pstmtlist| pstmt;

stmtlist: mstmt stmtlist| mstmt;
pstmt: dlabel| stmt; 
        | return ;

mstmt: dlabel| stmt;

stmt: assign|condjump|jump|readstmt|printstmt|callstmt
               |exit;

assign: id = opd arithop opd;
arithop: + | - | * | / ;
opd: id | num;

condjump: if id cmpop id goto label;
cmpop: < | > | <= | >= | = | <> ;

jump: goto label;

readstmt: read id;

printstmt: print printarg| println;

printarg: id | string;
callstmt: call id('arglist'); 
arglist: targlist|;

targlist: id , targlist|id;

%%

#include "lex.yy.c"
#include <ctype.h>

int main(int argc, char *argv[])
{
	symbol_table = create_table();
	constant_table = create_table();

	yyin = fopen(argv[1], "r");

	if(!yyparse())
	{
		printf("\nParsing complete\n");
	}
	else
	{
			printf("\nParsing failed\n");
	}


	printf("\n\tSymbol table");
	display(symbol_table);


	fclose(yyin);
	return 0;
}

int yyerror(char *msg)
{
	printf("Line no: %d Error message: %s Token: %s\n", yylineno, msg, yytext);
}

