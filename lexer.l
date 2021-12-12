%option yylineno
%option noinput nounput
%option noyywrap

%{

#include <stdlib.h>
#include <stdio.h>
#include "symboltable.h"
#include "tokens.h"

entry_t** symbol_table;
entry_t** constant_table;
int cmnt_strt = 0;

%}

alphabet [a-zA-Z]
digit [0-9]
ws  [ \t\r\f\v]+
identifier (_|{alphabet})({alphabet}|{digit}|_){0,31}

 /* Exclusive states */
%x CMNT

%%
  /* Keywords*/
"int"                             {printf("\t%-30s : %3d\n",yytext,INT);}
"var"                             {printf("\t%-30s : %3d\n",yytext,VAR);}
"long"                            {printf("\t%-30s : %3d\n",yytext,LONG);}
"long long"                       {printf("\t%-30s : %3d\n",yytext,LONG_LONG);}
"short"                           {printf("\t%-30s : %3d\n",yytext,SHORT);}
"signed"                          {printf("\t%-30s : %3d\n",yytext,SIGNED);}
"unsigned"                        {printf("\t%-30s : %3d\n",yytext,UNSIGNED);}
"return"                          {printf("\t%-30s : %3d\n",yytext,RETURN);}
"exit"                          {printf("\t%-30s : %3d\n",yytext,EXIT);}
"goto"                          {printf("\t%-30s : %3d\n",yytext,GOTO);}
"end"                          {printf("\t%-30s : %3d\n",yytext,END);}


{identifier}                      {printf("\t%-30s : %3d\n", yytext,IDENTIFIER);
                                  insert( symbol_table,yytext,IDENTIFIER );}
{ws}                              ;
[+\-]?{digit}+[lLuU]?              {printf("\t%-30s : %3d\n", yytext,DEC_CONSTANT);
									insert( constant_table,yytext,DEC_CONSTANT);}
"%"                              {cmnt_strt = yylineno; BEGIN CMNT;}
<CMNT>.|{ws}                      ;                       {yylineno++;}
<CMNT>"\n"                      {BEGIN INITIAL;}
"//".*                            ;

\"[^\"\n]*\"     {

  if(yytext[yyleng-2]=='\\') /* check if it was an escaped quote */
  {
    yyless(yyleng-1);       /* push the quote back if it was escaped */
    yymore();
  }
  else
  insert( constant_table,yytext,STRING);
 }
 
\"[^\"\n]*$                     {printf("Line %3d: Unterminated string %s\n",yylineno,yytext);}
{digit}+({alphabet}|_)+	        {printf("Line %3d: Illegal identifier name %s\n",yylineno,yytext);}
\n                              {yylineno++;}
"<="			                {printf("\t%-30s : %3d\n",yytext,LS_THAN_EQ);}
">="			                {printf("\t%-30s : %3d\n",yytext,GR_THAN_EQ);}
"=="			                {printf("\t%-30s : %3d\n",yytext,EQ);}
"<>"		                    {printf("\t%-30s : %3d\n",yytext,NOT_EQ);}
";"			                    {printf("\t%-30s : %3d\n",yytext,DELIMITER);}
","			                    {printf("\t%-30s : %3d\n",yytext,COMMA);}
"="			                    {printf("\t%-30s : %3d\n",yytext,ASSIGN);}
"("			                    {printf("\t%-30s : %3d\n",yytext,OPEN_PAR);}
")"			                    {printf("\t%-30s : %3d\n",yytext,CLOSE_PAR);}
"-"			                    {printf("\t%-30s : %3d\n",yytext,MINUS);}
"+"			                    {printf("\t%-30s : %3d\n",yytext,PLUS);}
"*"			                    {printf("\t%-30s : %3d\n",yytext,STAR);}
"/"		                        {printf("\t%-30s : %3d\n",yytext,FW_SLASH);}
"<"			                    {printf("\t%-30s : %3d\n",yytext,LS_THAN);}
">"			                    {printf("\t%-30s : %3d\n",yytext,GR_THAN);}
.                               {printf("Line %3d: Illegal character %s\n",yylineno,yytext);}

%%

int main()
{
  yyin=fopen("tests/test4.c","r");
  symbol_table=create_table();
  constant_table=create_table();
  yylex();
  printf("\n\tSymbol table");
  display(symbol_table);
  printf("\n\tConstants Table");
  display(constant_table);
  printf("NOTE: Please refer tokens.h for token meanings\n");
}