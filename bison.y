%output "parser.cxx"
%defines "parser.hxx"

%{
#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#define YYSTYPE std::string

std::istream *yyin;

extern "C" {
    int yyparse();
    int yylex();
    void yyerror(char *s){}
}

using namespace std;

void split(const string &s, char delim, vector<string> &elems) {
    stringstream ss;
    ss.str(s);
    string item;
    while (getline(ss, item, delim)) {
        elems.push_back(item);
    }
}

void yyerror(const char *str) {
	fprintf(stderr, "ошибка: %s\n", str);
}

int main() {
	cout<<yyparse()<<endl;
	return 0;
}

%}

%token plus multiple pow x digit

%%

S : E;
E : E plus T {
	string str = $1;
	string current = $3;
	string result = "";
	vector<string> summands;

	short a1, a2, b1, b2;
	if (current.find("x") != string::npos) {
		if (current.at(0) == 'x') a1 = 1;
		else a1 = current.at(0) - '0';
		if (current.back() == 'x') b1 = 1;
		else b1 = current.back() - '0';
	} else {
		b1 = 1;
		a1 = current.at(0) - '0';
	}

	split(str, '+', summands);

	for (string summand:summands) {
		if (summand.find("x") != string::npos) {
			if (summand.at(0) == 'x') a2 = 1;
			else a2 = summand.at(0) - '0';
			if (summand.back() == 'x') b2 = 1;
			else b2 = summand.back() - '0';
			if (b1 == b2) {
				if (current.find('x') != string::npos)
					summand.at(0) = (a1 + a2) + '0';
			}
		} else {
			char append = summand.at(0) + a1 - '0';
			summand.at(0) = append + '0';
		}
		result += summand + "+";
	}
	result = result.substr(0, result.size()-1);
	$$ = result;
  };
  | T;
T : K multiple x pow K {
  	$$ = $1 + "*x^" + $5;
  };
  | K { $$ = $1; };
  | x pow K { $$ = "x^" + $3; };
K : digit { $$ = $1; }
