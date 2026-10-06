#ifndef CMD_DATA_H
#define CMD_DATA_H
//datatypes and function are declared here
//Declar either union tag or struct
typedef struct CLObj {
    int INT;
    float FLT;
    char SYM;
    char Label;
} CLObj;

void name_list();

void function();

value_expression();

void long_option();

void arguments_list();

void command();

void command_list();

void evaluate(CLObj *);

#endif

