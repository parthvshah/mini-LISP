lex scanner.l
yacc -d parser.y
g++ y.tab.c lex.yy.c -ll
./a.out < test.txt