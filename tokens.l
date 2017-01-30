%option c++

%{
#include "parser.hxx"
extern YYSTYPE yylval;
extern "C" {
	int yylex();
	int yywrap();
}

int yyFlexLexer::yywrap() {
	return ::yywrap();
}
%}

%%
"^"    return pow;
"+"    return plus;
"*"    return multiple;
"x"    return x;
[2-4]  return digit;
%%
