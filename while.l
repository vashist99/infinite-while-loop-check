%{
    #include "y.tab.h"
%}

%%

"while"         {return WHILE;}
"exit"          {printf("over!"); return exit_command;}
[a-zA-Z]        {yylval.id = yytext[0]; return identifier;}
[0-9]+          {yylval.num = atoi(yytext); return number;}
[ \t\n]         ;
.               {return yytext[0];}

%%
int yywrap (void) 
{
    return 1;
    
}