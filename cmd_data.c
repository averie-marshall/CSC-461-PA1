#include "cmd_data.h"
#include <stdlib.h>
#include <string.h>

//implement the functions here

//blank node for any type we got int float char all up in thisplace
CLObj *new_obj(enum Type type) {
  CLObj *obj = calloc(1, sizeof(CLObj));
  if(obj == NULL) 
  {
    fprintf(stderr, "Womp womp no memory");
    //kill it 
    return NULL;
  }
  else
  {
    obj->type = type;
  }
  return obj;
}

//front
CLObj *front(CLObj *item, CLObj *list)
{
  item->next = list;
  return item;
}


//all the types now >:)
CLObj *new_int(long value) 
{
  CLObj *obj = new_obj(TINT);
  //check ig
  if(obj != NULL) 
  {
    obj->intV = value;
  }
  return obj;
}


CLObj *new_flt(double value) 
{
  CLObj *obj = new_obj(TFLT);
  if(obj != NULL) 
  {
    obj->fltV = value;
  }
  return obj;
}

CLObj *new_str(char *value) 
{
  CLObj *obj = new_obj(TSTR);
  if(obj != NULL) 
  {
    obj->strV = value;
  }
  return obj;
}

CLObj *new_sym(char *value)
{
  CLObj *obj = new_obj(TSYM);
  if(obj != NULL) 
  {
    obj->strV  = value;
  }
  return obj;
} 

CLObj *new_var(char *name)
{
  CLObj *obj = new_obj(TVAR);
  if(obj != NULL) 
  {
    obj->strV = name;
  }
  return obj;
}

CLObj *new_lopt( char *name, CLObj *value)
{
  CLObj *obj = new_obj(TLOPT);
  if(obj != NULL) 
  {
    obj->strV = name;
    obj->child = value;
  }
  return obj;
}

CLObj *new_flag(char *name)
{
  CLObj *obj = new_obj(TFLAG);
  if(obj != NULL) 
  {
    obj->strV = name;
  }
  return obj;
}

CLObj *new_com(char *name, CLObj *args)
{
  CLObj *obj = new_obj(TCOM);
  if(obj != NULL) 
  {
    obj->strV = name;
    obj->child = args;
  }
  return obj;
}

CLObj *new_fun( char *name, CLObj *param, CLObj *body)
{
  CLObj *obj = new_obj(TFUN);
  if(obj != NULL) {
    obj->strV = name;
    obj->child = param;
    obj->body = body;
  }
  return obj;
}

CLObj *new_pro( CLObj *elements)
{
  CLObj *obj = new_obj(TPRO);
  if(obj != NULL) {
    obj->child = elements;

  }
  return obj;
}

int count(CLObj *list)
{
  int count = 0;
  while(list != NULL) {
    count++;
    list = list->next;
  }
  return count;
}
/*
To print a string, print the word “STRING”, the length of the string, and then the content of the string, followed by a newline. This includes the quotation mark delimeters.
To print an integer, print the word “INTEGER”, the integer in base 10, and a newline.
Likewise, for float, print the word “FLOAT”, the float in base 10 (use %f), and a newline.
To print a flag, print “FLAG” then the flag name, then a newline.
To print a variable reference, print “VARREF”, the name of the variable, and a newline.
To print a symbol, print “SYMBOL”, the symbol name, and a newline.
To print a long option, print “LONG OPT”, the name of the long option, a newline, and print the value using this procedure.
To print a function, print “FUNCTION”, the name, and a newline. Then, print the word “ARGUMENTS” and the number of parameters and a newline, followed by each parameter using this procedure. The body must then be printed, by printing “BODY”, the number of commands in the body and a newline, and each command printed following this procedure
To print a command, print “COMMAND”, the name of the command, and a newline. Then, print the word “ARGS” followed by the number of arguments, and a newline. Then, print each argument following this procedure.
Finally, to print the whole program, print the word “PROGRAM”, the number of top-level elements in the program, and a newline. Then, print each command following this overall procedure.
*/

static void print_obj(CLObj *obj)
{
  CLObj *p;
 
  if(obj->type == TINT)
  {
    printf("INTEGER %ld\n", obj->intV);
  }
  else if(obj->type == TFLT)
  {
    printf("FLOAT %f\n", obj->fltV);
  }
  else if(obj->type == TSTR)
  {
    printf("STRING %d %s\n", (int)strlen(obj->strV), obj->strV);
  }
  else if(obj->type == TSYM)
  {
    printf("SYMBOL %s\n", obj->strV);
  }
  else if(obj->type == TVAR)
  {
    printf("VARREF %s\n", obj->strV);
  }
  else if(obj->type == TFLAG)
  {
    printf("FLAG %s\n", obj->strV);
  }
  else if(obj->type == TLOPT)
  {
    printf("LONG OPT %s\n", obj->strV);
    print_obj(obj->child);
  }
  else if(obj->type == TCOM)
  {
    printf("COMMAND %s\n", obj->strV);
    printf("ARGS %d\n", count(obj->child));
    for(p = obj->child; p != NULL; p = p->next)
    {
      print_obj(p);
    }
  }
  else if(obj->type == TFUN)
  {
    printf("FUNCTION %s\n", obj->strV);
    printf("ARGUMENTS %d\n", count(obj->child));
    for(p = obj->child; p != NULL; p = p->next)
    {
      print_obj(p);
    }
    printf("BODY %d\n", count(obj->body));
    for(p = obj->body; p != NULL; p = p->next)
    {
      print_obj(p);
    }
  }
  else if(obj->type == TPRO)
  {
    printf("PROGRAM %d\n", count(obj->child));
    for(p = obj->child; p != NULL; p = p->next)
    {
      print_obj(p);
    }
  }
}

//CLObj - object constructed or parse tree
//evaluate is what prints out the tree
void evaluate(CLObj *e)
{
  if(e != NULL)
  {
    print_obj(e);
  }
}
