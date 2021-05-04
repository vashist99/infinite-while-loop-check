%{
    void yyerror (char *s);
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int symbols[100];
    int temp;
    int yylex();
    int symbolVal(char symbol);
    void updateSymbolVal(char symbol,int val);
    int encodeExpInfo(int val, int expType);
    int getExpType(int val);
    int infWhileLoop();

    struct whileInfo{
        int limit;
        int gtlt;
        int incdec;
    };
    
%}


%union {int num; char id; struct conditionInfo{
        int varVal;
        int gtLt;
        int limit;
    } C;}
%start line
%token WHILE
%token lt
%token gt
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term
%type <num> assignment
%type <C> condition
%type <num> cond_op

%%


line:   assignment          {;} 
        |line assignment    {;}
        |exit_command       {exit(EXIT_SUCCESS);}
        |line exit_command  {exit(EXIT_SUCCESS);}
        |whileLoop          {;}
        |condition          {;}
        |line whileLoop     {;}
        ;

whileLoop: WHILE  '(' condition ')' '{' assignment '}'           {printf("while loop condition var:%d",$6);}
         ;


assignment  : identifier '=' exp {updateSymbolVal($1,$3);$$ = getExpType($3);}
            ;

exp         :   term                {$$ = $1;}
            |   exp '+' term        {temp = $1 + $3; $$ = encodeExpInfo(temp,1);}
            |   exp '-' term        {temp = $1 - $3; $$ = encodeExpInfo(temp,0);}
            ;

term        :   number              {$$ = $1;}
            |   identifier          {$$ = symbolVal($1);}
            ;

condition  :  identifier cond_op identifier     {$$.varVal = symbolVal($1); $$.limit = $3; $$.gtLt = $2;}
              |identifier cond_op number        {$$.varVal = symbolVal($1); $$.limit = $3; $$.gtLt = $2;}
              ;


cond_op   :  gt       {$$ = 1;}
            | lt      {$$ = 0;}  
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



int encodeExpInfo(int val, int expType){
    return val*10+expType;
}

int getExpType(int val){
    return val%10;
}

int main(void){
    int i;
    for(i=0;i<52;i++){
        symbols[i] = 0;
    }

    return yyparse();
}

void yyerror (char *s){fprintf (stderr, "%s\n",s);}