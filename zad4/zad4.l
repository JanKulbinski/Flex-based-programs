%{
#include <stdlib.h>
#include <string.h>
#include <math.h>

int currentStackLength = 0;
int x,y;
int errorType = 0;
char errorCharacter;

struct Node {
	int value;
	struct Node* next;	
};

typedef struct Node* Stack;

Stack insert(Stack first, int value) {
	Stack result = malloc(sizeof(struct Node));
	result->value = value;
	result->next = first;
	currentStackLength++; 
	return result;
}


int pop(Stack* first) {
	if(currentStackLength > 0) {
		int result = (*first)->value;
		*first = (*first)->next;
		currentStackLength--;
		return result;
	}
	return 0;
}

Stack pointer = NULL;

%}


%x ERROR


%%

-?[0-9]+	{
				ECHO;
				pointer = insert(pointer,atoi(yytext));
			}
			
\+			{
				ECHO;
				if(currentStackLength < 2) {
					errorType = 1;
					BEGIN(ERROR);
				}
         	x = pop(&pointer);
         	y = pop(&pointer);
            pointer = insert(pointer, x + y);
         }
         
\-			{
				ECHO;
				if(currentStackLength < 2) {
					errorType = 1;
					BEGIN(ERROR);
				}
         	x = pop(&pointer);
         	y = pop(&pointer);
            pointer = insert(pointer, y - x);
         }         
         
\*			{
				ECHO;
				if(currentStackLength < 2) {
					errorType = 1;
					BEGIN(ERROR);
				}
         	x = pop(&pointer);
         	y = pop(&pointer);
            pointer = insert(pointer, y * x);
         }
                  
\^			{
				ECHO;
				if(currentStackLength < 2) {
					errorType = 1;
					BEGIN(ERROR);
				}
         	x = pop(&pointer);
         	y = pop(&pointer);
            pointer = insert(pointer, (int) pow((double) y, (double) x));
         }
         
\/       {
				ECHO;
				if(currentStackLength < 2) {
					errorType = 1;
					BEGIN(ERROR);
				}
            x = pop(&pointer);
            y = pop(&pointer);
            if(x == 0) {
            	errorType = 3;
            	BEGIN(ERROR);
            } else {
              pointer = insert(pointer, y / x);
            }
         }
         
\%       {
				ECHO;
				if(currentStackLength < 2) {
					errorType = 1;
					BEGIN(ERROR);
				}
            x = pop(&pointer);
            y = pop(&pointer);
            if(x == 0) {
            	errorType = 3;
            	BEGIN(ERROR);
            } else {
              pointer = insert(pointer, y % x);
            }
          }

[ \t]    ECHO;

\n			{
				ECHO;
				if(currentStackLength == 1)
					printf("= %d\n", pop(&pointer));
				else if(currentStackLength == 0)
					printf("Error: too few arguments\n");
				else
					printf("Error: too few operators\n");
				pointer == NULL;
				currentStackLength = 0;	
			} 

.			{
				ECHO;
				errorCharacter = yytext[0];
				errorType = 4;
				BEGIN(ERROR);
			}

<ERROR>.  ECHO;
<ERROR>\n {
				ECHO;				
				switch(errorType) {
					case 1:
						printf("Error: too few arguments\n");
						break;
					case 2:
						printf("Error: too few operators\n");
						break;
					case 3:
						printf("Error: division by 0\n");
						break;
					case 4:
						printf("Error: wrong character: '%c'\n", errorCharacter);
						break;
					default:
						printf("Error:\n");
				}
				
				currentStackLength = 0;
				pointer = NULL;
				errorCharacter ='.';
				errorType = 0;
				BEGIN(INITIAL);
			}

%%

int yywrap(){} 
int main(){ 
	FILE *fp; 
	char filename[50] = "data.txt";;
	//scanf("%s",filename); 
	fp = fopen(filename,"r"); 
	yyin = fp;
	
	
	 
	yylex();
	return 0; 
}

