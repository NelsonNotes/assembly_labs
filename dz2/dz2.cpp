#include <iostream>
#include <string>
#include <vector>
#include <set>


using namespace std;

template<typename T>
vector<T> slice(vector<T> const &bigvec, int start, int end) {
    auto first = bigvec.cbegin() + start;
    auto last = bigvec.cbegin() + end;

    vector<T> vec(first, last);
    return vec;
}


int char_to_int(char symb) {
    return symb - '0';
}


bool isNumber( string s )
{
  for( char c : s )
  {
    if( !isdigit( c ) ) 
      return 0; 
  }
  return 1;
}

bool check_for_spec(char symb) {
    char symbols[6] = {';', '[', ']', '{', '}', ','};
    for (int i = 0; i < 6; i++) {
        if (symb == symbols[i]) {
            return true;
        }
    }
    return false;
}

enum Lex {
    TypePrefix,
    TypeDefinition,
    StructDefinition,
    Name,
    LSBracket,
    Count,
    RSBracket,
    LBrace,
    RBrace,
    Comma,
    Semicolon
};


Lex what_is_it(string cur_token) {
    set<string> types = {"int", "float", "char"};
    if (cur_token == "unsigned") {
        return TypePrefix;
    } else if (types.count(cur_token)) {
        return TypeDefinition;
    } else if (cur_token == "struct") {
        return StructDefinition;
    } else if (cur_token == "[") {
        return LSBracket;
    } else if (cur_token == "]") {
        return RSBracket;
    } else if (isNumber(cur_token)) {
        return Count;
    } else if (cur_token == "{") {
        return LBrace;
    } else if (cur_token == "}") {
        return RBrace;
    } else if (cur_token == ",") {
        return Comma;
    } else if (cur_token == ";") {
        return Semicolon;
    } else {
        return Name;
    }
}




vector<char> syntax_analyse(vector<string> tokens) {
    char cur_state = '0';
    vector<char> result;
    result.push_back('0');
    result.push_back('0');
    Lex token;
    char states[10][11] = {
        /*      tp   tn   sd   nm    [    c    ]    {    }    ,    ;  */
        /* 0 */{'1', '2', '6', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e'},
        /* 1 */{'e', '2', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e'},
        /* 2 */{'e', 'e', 'e', '3', 'e', 'e', 'e', 'e', 'e', 'e', 'e'},
        /* 3 */{'e', 'e', 'e', 'e', '4', 'e', 'e', 'e', 'e', '2', 'f'},
        /* 4 */{'e', 'e', 'e', 'e', 'e', '5', '3', 'e', 'e', 'e', 'e'},
        /* 5 */{'e', 'e', 'e', 'e', 'e', 'e', '3', 'e', 'e', 'e', 'e'},
        /* 6 */{'e', 'e', 'e', '7', 'e', 'e', 'e', 'e', 'e', 'e', 'e'},
        /* 7 */{'e', 'e', 'e', 'e', 'e', 'e', 'e', 'r', 'e', 'e', 'e'}, // after recursion returns to 8
        /* 8 */{'e', 'e', 'e', 'e', 'e', 'e', 'e', 'e', '9', 'e', 'e'},
        /* 9 */{'e', 'e', 'e', '3', 'e', 'e', 'e', 'e', 'e', 'e', 'f'}
    };
    for (int i = 0; i < tokens.size(); i++) {
        token = what_is_it(tokens[i]);
        clog << "Current token is: " << tokens[i] << endl;
        clog << "Current state is: " << cur_state << endl;
        cur_state = states[char_to_int(cur_state)][token];
        clog << "Going to state: " << cur_state << endl;
        clog << endl;
        if (cur_state == 'e') {
            result[0] = cur_state;
            result[1] = i;
            return result;
        } else if (cur_state == 'f') {
            result[0] = cur_state;
            result[1] = i+1; 
            return result;
        } else if (cur_state == 'r') {
            while (what_is_it(tokens[i+1]) != RBrace) {
                vector<string> sub_tokens = slice(tokens, i + 1, tokens.size());
                clog << "Entering recursion" << endl;
                result = syntax_analyse(sub_tokens);
                clog << "Returned from recursion" << endl;
                i += result[1];
                if (result[0] != 'f') {
                    return result;
                }
            }
            cur_state = '8';
        }
    }
    result[0] = cur_state;
    result[1] = -1;
    return result;
}



vector<string> scanner(string code) {
    vector<string> tokens;
    string cur_token;
    for (int i = 0; i < code.length(); i++) {
        if (code[i] == ' ') {
            if (cur_token != "") {
                tokens.push_back(cur_token);
                cur_token = "";
            }
        } else if (check_for_spec(code[i])) {
            if (cur_token != "") {
                tokens.push_back(cur_token);
                cur_token = "";   
            }
            tokens.push_back(string(1, code[i]));
        } else if (i == code.length()-1 && code[i] != ';') {
            if (cur_token != "") {
                cur_token += code[i];
                tokens.push_back(cur_token);
                cur_token = "";   
            }
        } else {
            cur_token += code[i];
        }
    }
    return tokens;
}

int main() {
    string str;
    clog << "Enter your code:" << endl;
    getline(cin, str);
    clog << endl;
    vector<string> tokens = scanner(str);
    for (int i = 0; i < tokens.size(); i++) {
        clog << "Token #" << i << ": " << tokens[i] << endl;
    }
    clog << endl;
    vector<char> result = syntax_analyse(tokens);
    if (result[0] == 'f') {
        clog << "OK!" << endl;
    } else if (result[0] == 'e') {
        clog << "Syntax error at " << (int)result[1]+1 << " position (\"" << tokens[result[1]] << "\" token)." << endl;
    } else {
        clog << "Error with state: " << result[0] << ", maybe you're forgot \";\"." << endl;
    }
}