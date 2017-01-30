all:
	bison bison.y
	flex -+ tokens.l
	g++ -o output.out parser.cxx lex.yy.cc -std=c++11 -lm -lfl
