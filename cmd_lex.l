%{
#include "cmd_data.h"
#include "cmd_parse.h"

#include <stdio.h>

#define YY_USER_ACTION \
    yylloc->first_line = yylloc->last_line; \
    yylloc->first_column = yylloc->last_column; \
    for(int i = 0; yytext[i] != '\0'; i++) { \
        if(yytext[i] == '\n') { \
            yylloc->last_line++; \
            yylloc->last_column = 0; \
        } \
        else { \
            yylloc->last_column++; \
        } \
    }

#define YY_USER_INIT \
  yy_set_interactive(yyin == stdin);

%}

%option outfile="cmd_lex.c" header-file="cmd_lex.h"


%option reentrant noyywrap
%option bison-bridge bison-locations
%%

\"([^\\\"]|\\.)*\"          { yylval->str_temp = strdup(yytext); return STR; }
-?[0-9]+\.[0-9]+            { yylval->flt_val = strtod(yytext, NULL); return FLT; }
[0-9]+                      { yylval->int_val = strtol(yytext, NULL, 10); return INT; }
[A-Za-z][A-Za-z0-9]+        { yylval->str_temp = strdup(yytext); return SYM; }
"%"                         { return VARREF; }
"/"                         { return OPTSTART; }
"="                         { return OPTPAIR; }
"."                         { return CMDSEP; }
"("                         { return LPAR; }
")"                         { return RPAR; }
"{"                         { return LBRACE; }
"}"                         { return RBRACE; }
"$"                         { return LABEL; }

[ \n\r\f\t]+                {}

.                           { fprintf(stderr, "Error: %d:%d: not allowed to use '%s'\n",
                                      yylloc->first_line, yylloc->first_column, yytext);
                              return YYUNDEF; }

%%