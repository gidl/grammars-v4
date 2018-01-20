
grammar CapnProto;

// parser rules

document :
	FILE_ID using namespace struct_def* EOF	;

using :
	'using' NAME '=' 'import' TEXT ';' ;
	
namespace :
	'$' NAME '.namespace(' TEXT ')' ';' ;
	
struct_def :
	'struct' NAME '{' struct_content* '}' ;

struct_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def ;

enum_def :
	'enum' NAME '{' enum_content* '}' ;
	
unnamed_union_def :
	'union' '{' field_def* '}' ;

type :
	':' type_name param_list? ';' ;

field_def :	
	NAME '@' INTEGER type ';' ;
	
enum_content :
	NAME '@' INTEGER ';' ;
	
named_union_def :
	NAME ':union' '{' field_def* '}' ;

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

FILE_ID : '@0x' HEX_DIGIT+ ;
