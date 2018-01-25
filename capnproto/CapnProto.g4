
grammar CapnProto;

// parser rules

document :
	FILE_ID ';' using namespace struct_def* EOF	;

using :
	'using' NAME '=' 'import' TEXT ';' ;
	
namespace :
	'$' NAME '.namespace(' TEXT ')' ';' ;
	
struct_def :
	'struct' NAME '{' struct_content* '}' ;

struct_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def ;

field_def :	
	NAME LOCATOR ':' type ';' ;

type :
	NAME ( '(' NAME ( ',' NAME )* ')' )? ;

enum_def :
	'enum' NAME '{' enum_content* '}' ;
	
enum_content :
	NAME LOCATOR ';' ;

named_union_def :
	NAME ':union' '{' field_def* '}' ;

unnamed_union_def :
	'union' '{' field_def* '}' ;

	
// lexer rules

fragment DIGIT : [0-9] ;

fragment HEX_DIGIT : DIGIT | 'A'..'F' | 'a'..'f' ;

LOCATOR : '@' DIGIT+ ;

TEXT : '"' ~["]*? '"' ;

INTEGER : DIGIT+ ;

FLOAT : DIGIT+ ( '.' DIGIT+ )? ;

FILE_ID : '@0x' HEX_DIGIT+ ;

NAME : [a-zA-Z] [a-zA-Z0-9]* ;

COMMENT : '#' ~[\n]* -> channel(HIDDEN) ;

WHITESPACE : [ \t\r\n] -> skip ;
