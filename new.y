/* FanC++.y */
%token BEG END RETURN IF ELSE WHILE FOR INT_ID
%token FLOAT_ID STRING_ID CHAR_ID BOOL_ID STRING DIGIT
%token COMMENT TRUE FALSE INT FLOAT CHAR IDENT ASSIGN
%token PLUS MINUS EQ MUL DIV SC LB RB LP RP LSB RSB DOT COMMA
%token HASHTAG AND OR DOL QM COLON STR_IDENT LT GT LTE GTE NEQ
%token CHECK_CONNECTION CONNECT_TO_URL READ_TEMP_DATA 
%token READ_HUMIDITY_DATA READ_PRESSURE_DATA READ_QUALITY_DATA
%token READ_LIGHT_DATA READ_SOUND_DATA READ_TIMER_DATA
%token SEND_DATA_TO_CONNECTION RECEIVE_DATA_FROM_CONNECTION
%token SWITCH_OFF SWITCH_ON IN OUT

%%
program: BEG stmt_list END;

stmt_list: stmt SC
        | stmt_list stmt SC;

stmt: matched|unmatched;

matched:IF LP logic_expr RP LB matched RB SC ELSE LB matched RB
        |loop_stmt
        |assign_stmt
        |declaration_stmt
        |return_stmt
        |call_stmt
        |ternary_stmt
        ;

unmatched: IF LP logic_expr RP LB stmt_list RB
        | IF LP logic_expr RP LB matched RB SC ELSE LB unmatched RB
        ;

loop_stmt: while_stmt
        |  for_stmt

while_stmt: WHILE LP logic_expr RP LB stmt_list RB 

for_stmt: FOR LP assign_stmt COMMA logic_expr COMMA logic_expr COMMA
              assign_stmt RP LB stmt_list RB
        | FOR LP var_declaration COMMA logic_expr COMMA logic_expr COMMA
              assign_stmt RP LB stmt_list RB  

return_stmt: RETURN expr
            |RETURN literal

ternary_stmt: logic_expr QM stmt COLON stmt


logic_expr: INT comparison_op INT
        |FLOAT comparison_op FLOAT
        |literal EQ literal
        |identifier comparison_op identifier
        ;

comparison_op: LT|GT|EQ|LTE|GTE|NEQ;

literal: STRING|CHAR|TRUE|FALSE;

assign_stmt: identifier ASSIGN expr
            |identifier ASSIGN and_or_expr
            |identifier ASSIGN literal
            |identifier ASSIGN call_stmt
            ;

expr: expr op1 term
    |term
    ;

term: term op2 factor
    |factor
    ;

factor: LP expr RP
    |val
    ;

val: identifier
    |FLOAT
    |INT
    ;

and_or_expr: and_or_expr OR term2
            | term2
            ;

term2: term2 AND factor
       | factor2
       ;

factor2: LP and_or_expr RP
         | val
         ; 



call_stmt:primitive_function;

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
                ;

url_connection:   CONNECT_TO_URL LP STRING RP;
check_connection: CHECK_CONNECTION LP STRING RP;
read_temp_data: READ_TEMP_DATA LP RP;
read_humidity_data: READ_HUMIDITY_DATA LP RP;
read_pressure_data: READ_PRESSURE_DATA LP RP;
read_quality_data: READ_QUALITY_DATA LP RP;
read_light_data:= READ_LIGHT_DATA LP RP;

read_sound_data: READ_SOUND_DATA LP RP;
read_timer_data:  READ_TIMER_DATA LP RP;

input: IDENT DOL;
output: IDENT DOL output_body; /*ADD IN&OUT*/


output_body:expr| and_or_expr| literal;

switch_id_list: DIGIT | DIGIT COMMA switch_id_list

op1:PLUS|MINUS;
op2:MUL|DIV;

identifier: IDENT;


declaration_stmt:var_declaration;

var_declaration:type_id ident_list
            |type_id assign_stmt

type_id:INT_ID|CHAR_ID|BOOL_ID|STRING_ID|FLOAT_ID;

ident_list:identifier
        |ident_list COMMA identifier
        ;
 
%%
#include "lex.yy.c"
void yyerror(char *s) { printf("%s", s); }
int main() {
 return yyparse();
}
