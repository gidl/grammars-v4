
grammar CapnProto;

// parser rules

document :
	file_identifier using_import* namespace? document_content* EOF	;

file_identifier :
	FILE_ID ';' ;
	
using_import :
	'using' ( NAME '=' )? 'import' TEXT ( '.' NAME )? ';' ;
	
namespace :
	'$' NAME '.namespace' '(' TEXT ')' ';' ;

document_content :
	struct_def | interface_def | function_def | annotation_def | const_def | enum_def ;

struct_def :
	'struct' type '{' struct_content* '}' ;

struct_content : 
	field_def | enum_def | named_union_def 
	| unnamed_union_def | interface_def | annotation_def
	| struct_def | group_def | const_def | inner_using ;

interface_def :
	'interface' type '{' interface_content* '}' ;

interface_content : 
	field_def | enum_def | named_union_def | unnamed_union_def | struct_def | function_def | interface_def ;

field_def :	
	NAME LOCATOR ':' type ( '=' const_value )? ';' ;

type :
	NAME 
	inner_type?
	( '.' NAME )? ;

inner_type :
	'(' type inner_type? ( ',' type inner_type? )* ')' ;
	
enum_def :
	'enum' NAME dollar_reference? '{' enum_content* '}' ;

dollar_reference :
	'$' NAME '.' NAME '(' TEXT ')' ;
	
enum_content :
	NAME LOCATOR dollar_reference? ';' ;

named_union_def :
	NAME LOCATOR? ':union' '{' union_content* '}' ;

unnamed_union_def :
	'union' '{' union_content* '}' ;

union_content :
	field_def | group_def | unnamed_union_def | named_union_def ;
	
group_def :
	NAME ':group' '{' group_content* '}' ;

group_content :
	field_def | unnamed_union_def | named_union_def ;
	
function_def :
	NAME LOCATOR function_parameters
	( '->' ( function_parameters | type ) )?	
	';' ;

function_parameters :
	'(' 
		( NAME ':' type ( ',' NAME ':' type )* )?
	')' ;
	
annotation_def :
	'annotation' type ':' type ';' ;
	
const_def :
	'const' NAME ':' type '=' const_value ';' ;
	
const_value :
	'-'? NAME | INTEGER | FLOAT | TEXT | BOOLEAN | HEXADECIMAL | VOID | literal_list | literal_union | literal_bytes ;
	
literal_union :
	'(' NAME '=' union_mapping ( ',' NAME '=' union_mapping )* ')' ;

literal_list :
	'[' const_value ( ',' const_value )* ']' ;

literal_bytes :
	'0x' TEXT ;
	
union_mapping :
	'(' NAME '=' const_value ')' | const_value ;

inner_using :
	'using' NAME ( '.' NAME )*
	( '=' type )?
	';' ;
	
	
// lexer rules

fragment DIGIT : [0-9] ;

fragment HEX_DIGIT : DIGIT | 'A'..'F' | 'a'..'f' ;

LOCATOR : '@' DIGIT+ '!'? ;

TEXT : '"' ~["]*? '"' ;

INTEGER : '-'? DIGIT+ ;

FLOAT : '-'? DIGIT+ ( '.' DIGIT+ )? ( 'e' '-'? DIGIT+ )? ;

HEXADECIMAL : '-'? '0x' HEX_DIGIT+ ;

FILE_ID : '@' HEXADECIMAL ;

BOOLEAN : 'true' | 'false' ;

VOID : 'void' ;

NAME : [a-zA-Z] [a-zA-Z0-9]* ;

COMMENT : '#' ~[\n]* -> channel(HIDDEN) ;

WHITESPACE : [ \t\r\n] -> skip ;
