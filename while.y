%{
    void yyerror (char *s);
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int symbols[100];
    int yylex();
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol,int val);
%}

%union {int num; char id;}
%start line
%token WHILE
%token lt
%token gt
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <id> assignment
%type <num> condition


%%


line:   assignment          {;} 
        |line assignment    {;}
        |exit_command       {exit(EXIT_SUCCESS);}
        |line exit_command  {exit(EXIT_SUCCESS);}
        |whileLoop          {;}
        |condition          {;}
        |line whileLoop {;}
        ;

whileLoop: WHILE  '(' condition ')' '{' assignment '}'           {printf("while loop condition var:%d\n",$3);}
         ;


assignment  : identifier '=' exp {updateSymbolVal($1,$3);}
            ;

exp         :   term                {$$ = $1;}
            |   exp '+' term        {$$ = $1 + $3;}
            |   exp '-' term        {$$ = $1 - $3;}
            ;

term        :   number              {$$ = $1;}
            |   identifier          {$$ = symbolVal($1);}
            ;

condition  :  identifier cond_op identifier     {$$ = symbolVal($1);}
              |identifier cond_op number        {$$ = symbolVal($1);}
              ;


cond_op   :  '>'
            | '<'
            ;

%%

int computeSymbolIndex(char token){
    int idx = -1;
    if(islower(token)){
        idx = token - 'a' +26;
    }
    else if(isupper(token)){
        idx = token - 'A' + 26;
    }
    return idx;
}

int symbolVal(char symbol){
    int bucket = computeSymbolIndex(symbol);
    return symbols[bucket];
}

void updateSymbolVal(char symbol, int val){
    int bucket = computeSymbolIndex(symbol);
    symbols[bucket] = val;
}

int main(void){
    int i;
    for(i=0;i<52;i++){
        symbols[i] = 0;
    }

    return yyparse();
}

void yyerror (char *s){fprintf (stderr, "%s\n",s);}