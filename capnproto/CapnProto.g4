
grammar CapnProto;

// parser rules

document :
	file_id using namespace struct_def* EOF	;
	
file_id :
	'@' HEX_NUMBER ';' ;

using :
	'using' NAME '=' 'import' TEXT ';' ;
	
namespace :
	'$' NAME '.namespace(' TEXT ')' ';' ;
	
struct_def :
	'struct' NAME '{' struct_decl* '}' ;

struct_decl	: 
	const_def | field | enum_def | named_union | unnamed_union | struct_def ;

enum_def :
	'enum' NAME '{' enum_decl* '}' ;

named_union :
	NAME ':union' '{' field* '}' ;
	
unnamed_union :
	'union' '{' field* '}' ;

type :
	':' type_name param_list? ';' ;
	
field :	
	NAME '@' INTEGER type ';' ;
	
const_def :
	'const' NAME '=' TEXT ;

enum_decl :
	NAME '@' INTEGER ';' ;
	
type_name : 
	BASE_TYPE_NAME | NAME ;

param_list :
	'(' type_name ( ',' type_name )* ')' ;

	
// lexer rules
	
BASE_TYPE_NAME : 'Void' | 'UInt32' | 'Text' | 'List' ;

// fragment LETTER : 'A'..'Z' | 'a'..'z' ;

fragment DIGIT : [0-9] ;

fragment HEX_DIGIT : DIGIT | 'A'..'F' | 'a'..'f' ;

COMMENT : '#' ~[\n]* -> channel(HIDDEN) ;

WHITESPACE : [ \t\r\n] -> skip ;

TEXT : '"' ~["]*? '"' ;

NAME : [a-zA-Z] [a-zA-Z0-9]* ;

INTEGER : DIGIT+ ;

FLOAT : DIGIT+ ( '.' DIGIT+ )? ;

HEX_NUMBER : '0x' HEX_DIGIT+ ;
