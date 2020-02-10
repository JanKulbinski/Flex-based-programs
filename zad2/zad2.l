/*
BEGIN  followed  by  the	name of a start condition
	      places the scanner in the corresponding start  con-
	      dition (see below).

ECHO copies yytext to the scanner's output.

yywrap() - wraps rule section 
*/

%{
#include <stdlib.h>
#include <string.h>
int legitComment = 1;
char* string = "";
char* concat(const char *s1, const char *s2) {
    char *result = malloc(strlen(s1) + strlen(s2) + 1);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}
%}

%x INSIDE_QUESTIONMARK
%x INSIDE_TAG
%x INSIDE_COMMENT

%%
\< {ECHO; BEGIN(INSIDE_TAG);}
<INSIDE_TAG>\" {ECHO; BEGIN(INSIDE_QUESTIONMARK);}
<INSIDE_TAG>. ECHO;
<INSIDE_TAG>\n ECHO;
<INSIDE_TAG>.> {ECHO; BEGIN(INITIAL);}


\<!-- {string = "<!--"; BEGIN(INSIDE_COMMENT);}
<INSIDE_COMMENT>--\> {
							if(legitComment) {
								strcpy(string,"");
							} else {
								legitComment = 1;
								string = concat(string,yytext);
								printf("%s",string);
								strcpy(string,"");
							}
							BEGIN(INITIAL);
						}
						
<INSIDE_COMMENT>-- {
							legitComment = 0;
 							string = concat(string,yytext);
  							printf("%s",string);
   						strcpy(string,"");
   					}
   					
<INSIDE_COMMENT>. {string = concat(string,yytext);}
<INSIDE_COMMENT>\n {string = concat(string,yytext);}


<INSIDE_QUESTIONMARK>\" {ECHO; BEGIN(INSIDE_TAG);}
<INSIDE_QUESTIONMARK>. ECHO;

. ECHO;
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
