%{
    #include "y.tab.h"
%}

%%

"while"         {return WHILE;}
"exit"          {return exit_command;}
\>              {return gt;}
\<              {return lt;}
[a-zA-Z]        {yylval.id = yytext[0]; return identifier;}
[0-9]+          {yylval.num = atoi(yytext); return number;}
[ \t\n]         ;
.               {return yytext[0];}

%%
int yywrap (void) 
{
    return 1;
    
}