# infinite-while-loop-check
A lex and yacc project to identify infinite while loops.


# How to run
Note: Make sure you enter your while loop in the "test" file with proper initializations.
## Installations:
- Lex
- Yacc
- gcc

## Commands to run:
- ```lex while.l```
- ```yacc -d while.y```
- ```gcc lex.yy.c y.tab.c -o whileLoop```
- ```./whileLoop <test```
