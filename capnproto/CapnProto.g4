
grammar CapnProto;

// parser rules

document :
	file_identifier using* namespace? document_content* EOF	;

file_identifier :
	FILE_ID ';' ;
	
using :
	'using' ( NAME '=' )? 'import' TEXT ( '.' NAME )? ';' ;
	
namespace :
	'$' NAME '.namespace' '(' TEXT ')' ';' ;

document_content :
	struct_def | interface_def | function_def | annotation_def | const_def | enum_def ;

struct_def :
	'struct' NAME '{' struct_content* '}' ;

struct_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def | group_def | const_def ;

interface_def :
	'interface' NAME '{' interface_content* '}' ;

interface_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def | function_def | interface_def ;

field_def :	
	NAME LOCATOR ':' type ( '=' literal_value )? ';' ;

type :
	NAME ( '(' ( NAME | 'enum' ) ( ',' NAME )* ')' )? ;

enum_def :
	'enum' NAME dollar_reference? '{' enum_content* '}' ;

dollar_reference :
	'$' NAME '.' NAME '(' TEXT ')' ;
	
enum_content :
	NAME LOCATOR dollar_reference? ';' ;

named_union_def :
	NAME ':union' '{' union_content* '}' ;

unnamed_union_def :
	'union' '{' union_content* '}' ;

union_content :
	field_def | group_def ;
	
group_def :
	NAME ':group' '{' field_def* '}' ;
	
function_def :
	NAME LOCATOR '(' ( NAME ':' type ( ',' NAME ':' type )* )? ')' '->' '(' NAME ':' type ')' ';' ;

annotation_def :
	'annotation' type ':' type ';' ;
	
const_def :
	'const' NAME ':' type '=' literal_value ';' ;
	
literal_value :
	INTEGER | FLOAT | TEXT | BOOLEAN | HEXADECIMAL ;
	

// lexer rules

fragment DIGIT : [0-9] ;

fragment HEX_DIGIT : DIGIT | 'A'..'F' | 'a'..'f' ;

LOCATOR : '@' DIGIT+ ;

TEXT : '"' ~["]*? '"' ;

INTEGER : DIGIT+ ;

FLOAT : DIGIT+ ( '.' DIGIT+ )? ;

HEXADECIMAL : '0x' HEX_DIGIT+ ;

FILE_ID : '@' HEXADECIMAL ;

BOOLEAN : 'true' | 'false' ;

NAME : [a-zA-Z] [a-zA-Z0-9]* ;

COMMENT : '#' ~[\n]* -> channel(HIDDEN) ;

WHITESPACE : [ \t\r\n] -> skip ;
