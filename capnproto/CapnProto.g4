
grammar CapnProto;

// parser rules

document :
	FILE_ID ';' using? namespace? document_content* EOF	;

using :
	'using' NAME '=' 'import' TEXT ';' ;
	
namespace :
	'$' NAME '.namespace' '(' TEXT ')' ';' ;

document_content :
	struct_def | interface_def | function_def ;

struct_def :
	'struct' NAME '{' struct_content* '}' ;

struct_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def ;

interface_def :
	'interface' NAME '{' interface_content* '}' ;

interface_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def | function_def | interface_def ;

field_def :	
	NAME LOCATOR ':' type ';' ;

type :
	NAME ( '(' NAME ( ',' NAME )* ')' )? ;

enum_def :
	'enum' NAME '{' enum_content* '}' ;
	
enum_content :
	NAME LOCATOR ';' ;

named_union_def :
	NAME ':union' '{' union_content* '}' ;

unnamed_union_def :
	'union' '{' union_content* '}' ;

union_content :
	field_def | group_def ;
	
group_def :
	NAME ':group' '{' field_def* '}' ;
	
function_def:
	NAME LOCATOR '(' ( NAME ':' type ( ',' NAME ':' type )* )? ')' '->' '(' NAME ':' type ')' ';' ;


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
