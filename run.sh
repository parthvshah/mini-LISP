g++ -c ASTTree.cc
lex scanner.l
yacc -d parser.y
g++ y.tab.c lex.yy.c ASTTree.cc -ll
./a.out < test2.txt

lex opt.l
yacc -d opt.y
gcc -g y.tab.c lex.yy.c -ll -o OPT
./OPT

lex assembler.l
yacc -d assembler.y
g++ -g y.tab.c lex.yy.c ASTTree.cc -ll -o ASSEM
./ASSEM < Optimize.txt