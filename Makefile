parser: y.tab.c lex.yy.c
	gcc -o parser y.tab.c
y.tab.c: CS315f22_team23.yacc
	yacc CS315f22_team23.yacc
lex.yy.c: CS315f22_team23.lex
	lex CS315f22_team23.lex
clean:
	-rm -f .o lex.yy.c.tab.* parser *.output