%{ 
int linesCount = 0;
int wordsCount = 0; 
%}

%%
^[ \t]*\n*  {printf("");}
[ \t]+$		{printf("");}
[ \t]+		{printf(" "); wordsCount++;}
\n				{printf("\n"); linesCount++; wordsCount++;}
%%

int yywrap(){}
int main(){ 
	FILE *fp; 
	char filename[50] = "data.txt";;
	//scanf("%s",filename); 
	fp = fopen(filename,"r"); 
	yyin = fp; 
	yylex();
   printf("Number of lines: %d\n", linesCount);
   printf("Number of words: %d\n", wordsCount);
return 0; 
} 
