%{
#include "main.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct datas
{
	char *name, *val;
	struct datas * next;
}Prop;
typedef struct
{
	char * name;
	Prop * hd;
}Label;

%}
%token NAME VALUE

%%

S:
	S comlabel {}
|	comlabel {}
;

comlabel:
	'<' label '>' {
		getlabel((Label *)$2, 0);
	}
|	'<' label '/' '>' {
		getlabel((Label *)$2, 1);
	}
|	'<' '/' NAME '>' {
		finishlabel($3);
	}
;

label:
	label property {
		Label * tmp1 = (Label *)$1;
		Prop * tmp2 = (Prop *)$2;
		tmp2->next = tmp1->hd;
		tmp1->hd = tmp2;
		//printf("label Property: %s %s\n",tmp2->name,tmp2->val);
		$$ = (char *)tmp1;
	}
|	NAME {
	Label * tmp = (Label *)malloc(sizeof(Label));
	tmp->name = $1; tmp->hd = NULL;
	$$ = (char *)tmp;
}
;


property:
	NAME '=' VALUE {
		Prop * tmp = (Prop *)malloc(sizeof(Prop));
		//printf("%d",strlen($3));
		//tmp->name = (char *)malloc(sizeof(char)*(1+strlen($1))); memcpy(tmp->name, $1, strlen($1)+1);
		//tmp->val = (char *)malloc(sizeof(char)*(1+strlen($3))); memcpy(tmp->val, $3, strlen($3)+1);
		//printf("SS:%s\n",tmp->name);
		tmp->name = $1; tmp->val = $3;
		tmp->next = NULL;
		$$ = (char *)tmp;
	}
;
%%

int main()  
{  
    yyparse();  
    return 0;  
}  
  
int yyerror(char *s)  
{  
    printf("error: %s\n",s);  
    return 0;  
}

void getlabel(Label* s,int flag)
{
	printf("getlabel: %s %d\n" ,s->name ,flag);
	Prop* tmp = s->hd;
	while (tmp!=NULL)
	{
		printf("%s=%s\n", tmp->name, tmp->val);
		tmp = tmp->next;
	}
	printf("\n");
}

void finishlabel(char * name)
{
	printf("%s finished\n" ,name);
}