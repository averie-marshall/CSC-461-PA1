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
    long int_val;
    double flt_val;
    CLObj* obj;
}
//Declare tokens here
%token VARREF
%token OPTSTART
%token OPTPAIR
%token CMDSEP
%token LPAR
%token RPAR
%token LBRACE
%token RBRACE
%token LABEL
%token <str_temp> STR
%token <str_temp> SYM
%token <int_val> INT
%token <flt_val> FLT


/* TODO: Fill in the parser */
%type <obj> variable name_list function value_expression long_option
%type <obj> command arguments_list command_list

%%

/* TODO: Your top-level rule should put an object of type CLObj* into *expression */
input:          command_list { *expression = new_pro($1); };

variable: VARREF SYM { $$ = new_var($2); };

name_list:      %empty 
          {
                $$ = NULL;
          }

             | variable name_list
          {
             $$ = front($1, $2);
          };

function: LABEL SYM LPAR name_list RPAR LBRACE command_list RBRACE
            { $$ = new_fun($2, $4, $7); }
          ;

value_expression:
            SYM { $$ = new_sym($1); }
          | INT { $$ = new_int($1); }
          | FLT { $$ = new_flt($1); }
          | STR { $$ = new_str($1); }
          | variable { $$ = $1; }
          | LPAR command RPAR { $$ = $2; }
          ;

//May be wrong. I couldn't figure out what OPTPAIR does.
long_option:  OPTSTART SYM { $$ = new_flag($2); }
          | OPTSTART SYM OPTPAIR value_expression { $$ = new_lopt($2, $4); }
          ;

arguments_list: %empty {$$ = NULL; }
          | value_expression arguments_list {$$ = front($1, $2); }
          | long_option arguments_list {$$ = front($1, $2); }
          ;

command: SYM arguments_list { $$ = new_com($1, $2); };

command_list: %empty { $$ = NULL; }
          | function command_list { $$ = front($1, $2); }
          | command CMDSEP command_list { $$ = front($1, $3); };

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