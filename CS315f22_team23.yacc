/* FanC++.y */
%{
#include <stdio.h>
%}

%token BEG END RETURN IF ELSE WHILE FOR DIGIT INT_ID
%token FLOAT_ID STRING_ID CHAR_ID BOOL_ID STRING 
%token COMMENT TRUE FALSE INT FLOAT CHAR IDENT ASSIGN
%token PLUS MINUS EQ MUL DIV SC LB RB LP RP LSB RSB DOT COMMA
%token HASHTAG AND OR DOL QM COLON STR_IDENT LT GT LTE GTE NEQ
%token CHECK_CONNECTION CONNECT_TO_URL READ_TEMP_DATA 
%token READ_HUMIDITY_DATA READ_PRESSURE_DATA READ_QUALITY_DATA
%token READ_LIGHT_DATA READ_SOUND_DATA READ_TIMER_DATA
%token SEND_DATA_TO_CONNECTION RECEIVE_DATA_FROM_CONNECTION
%token SWITCH_OFF SWITCH_ON IN OUT NL 

%%
program: BEG stmt_list END {printf("program valid\n"); return 0;};

stmt_list: stmt 
        |stmt_list stmt 
        ;
        

stmt: matched |unmatched SC |COMMENT | error  

matched:IF LP logic_expr RP LB matched RB SC ELSE LB matched RB SC
        |loop_stmt SC
        |assign_stmt SC
        |declaration_stmt SC
        |return_stmt SC
        |call_stmt SC
        |ternary_stmt
        ;

unmatched: IF LP logic_expr RP LB stmt_list RB
        | IF LP logic_expr RP LB matched RB SC ELSE LB unmatched SC RB
        ;

loop_stmt: while_stmt
        |  for_stmt
        ;

while_stmt: WHILE LP logic_expr RP LB stmt_list RB ;

for_stmt: FOR LP assign_stmt SC logic_expr SC
              assign_stmt RP LB stmt_list RB
        | FOR LP var_declaration SC logic_expr SC
              assign_stmt RP LB stmt_list RB  
        ;

return_stmt: RETURN expr
            |RETURN literal
        ;

ternary_stmt: logic_expr QM stmt stmt;


logic_expr: INT comparison_op INT
        |DIGIT comparison_op DIGIT
        |FLOAT comparison_op FLOAT
        |literal comparison_op literal
        |identifier comparison_op val
        |identifier comparison_op literal
        ;

comparison_op: LT|GT|EQ|LTE|GTE|NEQ;

literal: STRING|CHAR|TRUE|FALSE;

assign_stmt: identifier ASSIGN expr
            |identifier ASSIGN literal
            |identifier ASSIGN call_stmt
            ;

expr: expr OR and_term
    |and_term
    ;

and_term: and_term AND add_sub_term
    |add_sub_term
    ;

add_sub_term: add_sub_term op1 mul_div_term
    |mul_div_term
    ;

mul_div_term: mul_div_term op2 factor
    |factor
    ;

factor: LP expr RP
    |val
    ;

val: identifier
    |FLOAT
    |INT
    |DIGIT
    ;


call_stmt:primitive_function
          |non_primitive_function
          ;
          
non_primitive_function: identifier LP function_input RP;

function_input: identifier COMMA function_input 
                |literal COMMA function_input
                |INT COMMA function_input 
                |FLOAT COMMA function_input
                |identifier
                |INT
                |FLOAT
                |literal
                ;

primitive_function: input
                |output
                |check_connection
                |read_temp_data
                |read_humidity_data
                |read_pressure_data
                |read_quality_data
                |read_light_data
                |url_connection
                |read_sound_data
                |read_timer_data
                |switch_on
                |switch_off
                |send_data_to_connection
                |receive_data_from_connection
                ;

url_connection:   CONNECT_TO_URL LP STRING RP;
check_connection: CHECK_CONNECTION LP STRING RP;
read_temp_data: READ_TEMP_DATA LP RP;
read_humidity_data: READ_HUMIDITY_DATA LP RP;
read_pressure_data: READ_PRESSURE_DATA LP RP;
read_quality_data: READ_QUALITY_DATA LP RP;
read_light_data: READ_LIGHT_DATA LP RP;
read_sound_data: READ_SOUND_DATA LP RP;
read_timer_data:  READ_TIMER_DATA LP RP;
input: IN DOL;
output: OUT DOL output_body; 
switch_on: SWITCH_ON LP switch_id_list RP;
switch_off: SWITCH_OFF LP switch_id_list RP;
send_data_to_connection:  SEND_DATA_TO_CONNECTION LP STRING COMMA INT RP
            |SEND_DATA_TO_CONNECTION LP STRING COMMA identifier RP;
            |SEND_DATA_TO_CONNECTION LP STRING COMMA DIGIT RP;
receive_data_from_connection: RECEIVE_DATA_FROM_CONNECTION LP STRING RP;


output_body:expr|literal;

switch_id_list: DIGIT | DIGIT COMMA switch_id_list;

op1:PLUS|MINUS;
op2:MUL|DIV;

identifier: IDENT;


declaration_stmt:var_declaration
            |function_decleration;

var_declaration:type_id ident_list
            |type_id assign_stmt;

type_id:INT_ID|CHAR_ID|BOOL_ID|STRING_ID|FLOAT_ID;

ident_list:identifier
        |ident_list COMMA identifier
        ;

function_decleration: function_header LB stmt_list RB;

function_header: identifier LP param_list RP;

param_list: /*empty*/ | type_id identifier 
            | type_id identifier COMMA param_list
            ;



%%
#include "lex.yy.c"
int lineno = 1;
int error = 0;

main() {
  yyparse();
  if (error == 0) {
    printf("Input program is valid.\n");
  }
  return 0;
}

yyerror( char *s ) {
    error = -1;
    fprintf( stderr, "%s on line %d!\n", s, lineno);
}