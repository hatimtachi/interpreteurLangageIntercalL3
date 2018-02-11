%{
#define YYDEBUG 1
enum Bool { False = 0, True = 1};
  Bool letable=False;
  char Tableau[100];
  int yydebug=0;
  int taille=0;
  int tab[7];
  char le_char;
  int x=256;
  int head=0;
  extern int yyerror(char *);
  extern int yylex(void);

  %}

%union{
  int val;
  char car;
}
%left  <code> ',' '#' '<''-'
%token <car> CARACTERE
%token  GIVE_UP READ_OUT
%token DO PLEASE SUB 

%type <car> ligne expr  DO
%token NUMBRE
%type <code> GETS ick_ONESPOT MESH


%%
ligne	:expr 
    	;

GETS	:'<''-'
	;

ick_ONESPOT:','
	;
MESH	:'#'
	;

expr  	:DO PROGRAM
      	|PLEASE DO PROGRAM
      	|PLEASE READ_OUT
      	|PLEASE GIVE_UP{return;}
      	;

PROGRAM	:ick_ONESPOT numbre NEXT
                {letable=True;}
	|NEXT3
       	;

NEXT3	:ick_ONESPOT numbre GETS MESH number
	{la_convertion_bizzare($5);}
	;

NEXT 	:GETS MESH number
               {if(letable){
			<val>x=$3;
			Tableau[x];
		}
	}
    	|SUB MESH NEXT2
     	;

NEXT2	: number GETS MESH numbre
		{la_convertion_bizzare($3);}
	|numbre
		{$$=$1;}
	;
numbre	:NUMBRE
	| numbre NUMBRE
	;
%%

# include <stdio.h>
# include <ctype.h>  // isdigit etc.
# include <assert.h>

/* yyerror  --  appelÃ©e par yyparse en cas d'erreur */
int
yyerror(char * s){
  fprintf(stderr, "%s\n", s);
  return 0;
}

/* yylex  --  appelÃ©e par yyparse pour avoir le mot suivant */
int
yylex(void){
  int c, t;
  char *p;
  p=malloc(sizeof(char)*100);
 re:
  while(isspace(c = getchar()))
    if (c == '\n')
      return c;

  if (c == EOF)
    return 0;

  if (c == '-')
    return c;

  if (c == ';')
    return '\n';

  if (isdigit(c)){
    ungetc(c, stdin);
    t = scanf("%s", p);
    assert(t == 1);
    yylval.car = p;
    return PLEASE;
  }

  fprintf(stderr, "CaractÃ¨re ignorÃ© %c\n", c);
  goto re;
}


/*
*cette fonction saispour convertion du number to binary
*/
int convertir_to_binary(int x){
  int x8=128,x7=64,x6=32,x5=16,x4=8,x3=4,x2=2,x1=1;
  int n=0;
  while(n<=7){
    tab[n]=0;
    n++;
  }
  while(x){
    if(x>=x8){
      x-=x8;
      tab[7]=1;
    }
    else if(x>=x7){
      x-=x7;
      tab[6]=1;
    }
    else if(x>=x6){
      x-=x6;
      tab[5]=1;
    } 
    else if(x>=x5){
      x-=x5;
      tab[4]=1;
    }
    else if(x>=x4){
      x-=x4;
      tab[3]=1;
    }
    else if(x>=x3){
      x-=x3;
      tab[2]=1;
    }
    else if(x>=x2){
      x-=x2;
      tab[1]=1;
    }
    else if(x>=x1){
      x-=x1;
      tab[0]=1;
    }
  }
  n=7;
  while(n>=0){
    printf("%d\n",tab[n]);
    n--;
  }
  return tab;
}

/*
*cette fonction sais pour convertion du le binary a decimal ascii pour pouvoir le trouver le char apres 
*/
int binaryto_ascii_decimal(){
    int x8=128,x7=64,x6=32,x5=16,x4=8,x3=4,x2=2,x1=1;
    int n=0;
    int res=0;
    while(n<=7){
      if((tab[n]==1)&&(n==0)){
	res+=x8;
      }
      else if((tab[n]==1)&&(n==1)){
	res+=x7;
      }
      else if((tab[n]==1)&&(n==2)){
	res+=x6;
      }
      else if((tab[n]==1)&&(n==3)){
	res+=x5;
      }
      else if((tab[n]==1)&&(n==4)){
	res+=x4;
      }
      else if((tab[n]==1)&&(n==5)){
	res+=x3;
      }
      else if((tab[n]==1)&&(n==6)){
	res+=x2;
      }
      else if((tab[n]==1)&&(n==7)){
	res+=x1;
      }
      n++;
    }
    return res;
}
/*
*cette fonction sais pour avoir le char du decimal ascii
*/
void ascii_decimal_to_char(int x){
  char debut='NULL';
  while(debut!='DEL'){
    if(debut==x){
      lechar=debut;
      return;
    }
    debut++;
  }
}
/*
*la fonction principale pour la converstion de l'entre 
*/
void la_convertion_bizzare(int get){
  int root=1;
    get=x-get;
    get+=head;
    head=get;
    if(get>=256){
      get=get-256;
      head=get;
    }
    convertir_to_binary(get);
    ascii_decimal_to_char( binaryto_ascii_decimal());
}

int
main(){
  printf("? ");
  yyparse();
  printf("Bye\n");
  return 0;
}
