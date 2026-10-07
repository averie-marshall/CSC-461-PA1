#ifndef CMD_DATA_H
#define CMD_DATA_H
//datatypes and function are declared here
//Declar either union tag or struct\

//we are gonna use some defining because I lowkey don't know how to get around it otherwise
#define INT 1
#define FLT 2
#define STR 3
#define SYM 4
#define VAR 5
#define FLAG 6
#define OPT 7
#define COM 8
#define FUN 9
#define PRO 10



//declaring the types and what they mean #idek 
typedef struct CLObj {
    int type;
    long intV;
    double fltV;
    char *strV;

    //linked list start
    struct CLObj *child;
    struct CLObj *list;
    struct CLObj *body;
    struct CLObj *next;
} CLObj;


//declare new tyoes
CLObj *createInt(long v);
CLObj *createFlt(double v);
CLObj *createStr(char *s);
CLObj *createSym(char *s);
CLObj *createVar(char *s);




CLObj *name_list(CLObj *type, CLObj *name);

CLObj *function(char *name, CLObj *p, CLObj *body);

CLObj *value_expression();

CLObj *long_option(char *name, CLObj *type);

CLObj *arguments_list(CLObj *arg, CLObj *rest);

CLObj *command(char *name, CLObj *args);

CLObj *command_list();

void evaluate(CLObj *);

#endif

