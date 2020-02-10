%{
#include <stdlib.h>
int ifDoc = 1;
%}

%x IN_COMMENT_LINE
%x IN_DOC_COMMENT_LINE
%x IN_COMMENT
%x IN_DOC_COMMENT
%x IN_QUESTIONMARK
%x IN_HEADER


%%

"#include <" 	{ECHO; BEGIN(IN_HEADER);}
<IN_HEADER>> 	{ECHO; BEGIN(INITIAL);}
<IN_HEADER>["] {ECHO; BEGIN(IN_QUESTIONMARK);}
<IN_HEADER>. 	ECHO;


["] 						 {ECHO; BEGIN(IN_QUESTIONMARK);}
<IN_QUESTIONMARK>\\\" ECHO;
<IN_QUESTIONMARK>["]  {ECHO; BEGIN(INITIAL);}
<IN_QUESTIONMARK>. 	 ECHO;


(\/\/\/.)|(\/\/\!.) 			 BEGIN(IN_DOC_COMMENT_LINE); 
<IN_DOC_COMMENT_LINE>\\\n|. {
										if(ifDoc)
											printf("");
										else
											ECHO;
									 }
<IN_DOC_COMMENT_LINE>\n     {ECHO; BEGIN(INITIAL);}

							
\/(\\\n)*\/ 					 	 BEGIN(IN_COMMENT_LINE);
<IN_COMMENT_LINE>\\\n printf("");
<IN_COMMENT_LINE>. 	 printf("");
<IN_COMMENT_LINE>\n   {ECHO; BEGIN(INITIAL);}



(\/\*\*)|(\/\*\!)		BEGIN(IN_DOC_COMMENT);
<IN_DOC_COMMENT>\*\/ BEGIN(INITIAL);
<IN_DOC_COMMENT>.|\n {
							if(ifDoc)
								printf("");
							else
								ECHO;
							}					


\/\* 						BEGIN(IN_COMMENT);
<IN_COMMENT>.			printf(""); 
<IN_COMMENT>\n 		printf("");
<IN_COMMENT>\*\/		BEGIN(INITIAL);


%%


int yywrap(){} 
int main() { 
	FILE *fp; 
	char filename[50] = "data.txt";;
	//scanf("%s",filename); 
	fp = fopen(filename,"r"); 
	yyin = fp; 
	yylex();
return 0; 
} 
