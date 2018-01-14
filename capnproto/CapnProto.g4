
grammar CapnProto;

// parser rules

document :
	file_id using namespace struct* EOF	;
	
file_id :
	'@' HEX_NUMBER ';' ;

using :
	'using' NAME '=' 'import' TEXT ';' ;
	
namespace :
	'$' NAME '.namespace(' TEXT ')' ';' ;
	
struct :
	'struct' NAME '{' declaration* '}' ;

declaration	: 
	field_decl | unnamed_enum | named_enum  | const_decl ;

named_enum :
	'enum' NAME '{' enum_decl* '}' ;
	
unnamed_enum :
	'enum' '{' enum_decl* '}' ;

type :
	':' type_name param_list? ';' ;
	
field_decl :	
	NAME '@' INTEGER type ';' ;
	
const_decl :
	'const' NAME '=' TEXT ;

enum_decl :
	NAME LOCATION ';' ;
	
type_name : 
	BASE_TYPE_NAME | NAME ;

param_list :
	'(' type_name ( ',' type_name )* ')' ;

	
// lexer rules
	
BASE_TYPE_NAME : 'Void' | 'UInt32' | 'Text' | 'List' ;

TEXT : '"' ~["]*? '"' ;

FLOAT : DIGIT+ ( '.' DIGIT+ )? ;

INTEGER : DIGIT+ ;

NAME : LETTER ( LETTER | DIGIT )* ;

HEX_NUMBER : '0x' HEX_DIGIT+ ;

fragment LETTER : 'A'..'Z' | 'a'..'z' ;

fragment DIGIT : '0'..'9' ;

fragment HEX_DIGIT : DIGIT | 'A'..'F' | 'a'..'f' ;

COMMENT : '#' ~[\n]*? -> channel(HIDDEN) ;

WHITESPACE : [ \t\r\n] -> skip ;