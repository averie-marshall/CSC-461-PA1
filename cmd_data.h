#ifndef CMD_DATA_H
#define CMD_DATA_H
//datatypes and function are declared here
//Declar either union tag or struct
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

//we are gonna use some defining because I lowkey don't know how to get around it otherwise
//enum recomended 
/*#define INT 1
#define FLT 2
#define STR 3
#define SYM 4
#define VAR 5
#define FLAG 6
#define OPT 7
#define COM 8
#define FUN 9
#define PRO 10
*/

//looked this up as discussed in class :)
enum Type {
    TINT,
    TFLT,
    TSTR,
    TSYM,
    TVAR,
    TFLAG,
    TLOPT,
    TCOM,
    TFUN,
    TPRO
};


//declaring the types and what they mean #idek 
typedef struct CLObj {
    enum Type type;
    long intV;
    double fltV;
    char *strV;

    //linked list start
    struct CLObj *child;
    //struct CLObj *list;
    struct CLObj *body;
    struct CLObj *next;
} CLObj;


//one in da front too
CLObj *front(CLObj *item, CLObj *list);
//declare new tyoes
CLObj *new_int(long v);
CLObj *new_flt(double v);
CLObj *new_str(char *s);
CLObj *new_sym(char *s);
CLObj *new_var(char *name);
CLObj *new_flag(char *name);
CLObj *new_lopt(char *name, CLObj *value);
CLObj *new_com(char *name, CLObj *args);
CLObj *new_fun(char *name, CLObj *param, CLObj *body);
CLObj *new_pro(CLObj *elements);



/*
CLObj *name_list(CLObj *type, CLObj *rest);

CLObj *function(char *name, CLObj *par, CLObj *body);

CLObj *value_expression();

CLObj *long_option(char *name, CLObj *type);

CLObj *arguments_list(CLObj *arg, CLObj *rest);

CLObj *command(char *name, CLObj *args);

CLObj *command_list(CLObj *item, CLObj *rest);
*/
void evaluate(CLObj *);

#endif

