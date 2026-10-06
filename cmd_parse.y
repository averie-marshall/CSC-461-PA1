%{
#include "cmd_data.h"
#include "cmd_parse.h"
#include "cmd_lex.h"

#define YYPARSE_PARAM scanner
#define YYLEX_PARAM scanner

int yyerror(YYLTYPE*, CLObj**, yyscan_t, const char*);

void print_loc(FILE*, YYLTYPE);
#define YYLOCATION_PRINT print_loc

%}
%locations

%code requires {
    typedef void *yyscan_t;
}

%output "cmd_parse.c"
%defines "cmd_parse.h"

%define api.pure full
%define parse.error custom
%lex-param { yyscan_t scanner }
%parse-param { CLObj **expression }
%parse-param { yyscan_t scanner }

%union {
    char* str_temp;
}
//Declare tokens here
%%
%token VARREF
%token OPSTAR
%token OPTPAIR
%token CMDSEP
%token LPAR
%token RPAR
%token LBRACE
%token RBRACE
%token LABEL
%token <str_temp> STR
%token SYM
%token INT
%token FLT

/* TODO: Fill in the parser */

/* TODO: Your top-level rule should put an object of type CLObj* into *expression */
input:          command_list { *expression = $1; };

input ::= <command_list>

variable ::= VARREF SYM
sym: SYM;
int: INT;
float: FLT;
string: STR;

name_list:      %empty 
          {
                $$ = NULL;
          }

             | variable name_list
          {
                Node* newnode = malloc(sizeof(Node));
                newnode->name = $1;
                newnode->next = $2;
                $$ = newnode;
          };

function: LABEL SYM LPAR <name_list> RPAR LBRACE <command_list> RBRACE
            $$ = name_list { $2, $4, $7 };
          ;

value_expression:
            SYM { $$ = $1 };
          | INT { $$ = $1 };
          | FLT { $$ = $1 };
          | STR { $$ = $1 };
          | variable { $$ = $1 };
          | LPAR command RPAR { $$ = $2 };
          ;

//May be wrong. I couldn't figure out what OPTPAIR does.
long_option: OPTSTART SYM | OPTSTART SYM OPTPAIR value_expression
            OPTSTART SYM { $$ = $1 };
          | OPTSTART SYM OPTPAIR value_expression { }
          ;

arguments_list: empty | value_expression arguments_list | long_option arguments_list;

command: SYM arguments_list;

command_list: empty | function command_list | command CMDSEP command_list;

%%

/* The code below produces more helpful syntax errors. */
int
yyreport_syntax_error (const yypcontext_t *ctx, CLObj **expr, yyscan_t scanner)
{
  int res = 0;
  YYLOCATION_PRINT (stderr, *yypcontext_location (ctx));
  fprintf (stderr, ": syntax error");
  // Report the tokens expected at this point.
  {
    enum { TOKENMAX = 5 };
    yysymbol_kind_t expected[TOKENMAX];
    int n = yypcontext_expected_tokens (ctx, expected, TOKENMAX);
    if (n < 0)
      // Forward errors to yyparse.
      res = n;
    else
      for (int i = 0; i < n; ++i)
        fprintf (stderr, "%s %s",
                 i == 0 ? ": expected" : " or", yysymbol_name (expected[i]));
  }
  // Report the unexpected token.
  {
    yysymbol_kind_t lookahead = yypcontext_token (ctx);
    if (lookahead != YYSYMBOL_YYEMPTY)
      fprintf (stderr, " before %s", yysymbol_name (lookahead));
  }
  fprintf (stderr, "\n");
  return res;
}

void print_loc(FILE* stream, YYLTYPE loc)
{
    if (loc.first_line == loc.last_line)
        fprintf(stream, "Error: %d:(%d-%d)",
                loc.first_line,
                loc.first_column,
                loc.last_column);
    else
        fprintf(stream, "Error: %d:%d-%d:%d",
                loc.first_line,
                loc.first_column,
                loc.last_line,
                loc.last_column);
}
