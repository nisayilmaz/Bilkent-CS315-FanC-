/* FanC++.y */
%token BEG END RETURN IF ELSE WHILE FOR INT_ID
%token FLOAT_ID STRING_ID CHAR_ID BOOL_ID STRING
%token COMMENT TRUE FALSE INT FLOAT CHAR IDENT ASSIGN
%token PLUS MINUS EQ MUL DIV SC LB RB LP RP LSB RSB DOT COMMA
%token HASHTAG AND OR DOL QM COLON STR_IDENT LT GT LTE GTE
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
        |assign_stmt
        |declaration_stmt
        |call_stmt
        ;

unmatched: IF LP logic_expr RP LB stmt_list RB
        | IF LP logic_expr RP LB matched RB SC ELSE LB unmatched RB
        ;

logic_expr: INT comparison_op INT
        |FLOAT comparison_op FLOAT
        |literal EQ literal
        |identifier comparison_op identifier
        ;

comparison_op: LT|GT|EQ|LTE|GTE;

literal: STRING|CHAR|TRUE|FALSE;

assign_stmt: identifier ASSIGN expr
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

call_stmt:primitive_function;

primitive_function: input
                |output
                ;

input: IDENT DOL;
output: IDENT DOL output_body; /*ADD IN&OUT*/


output_body:expr|literal;


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