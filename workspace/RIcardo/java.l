/* 
 * Archivo: java.l
 * Descripción: Reconocedor de identificadores válidos en Java
 * Compilación y prueba:
 *    flex java.l
 *    gcc lex.yy.c -o java_parser
 *    ./java_parser
 */

%{
#include <stdio.h>
%}

/* Definiciones básicas */
/* Letra: a-z, A-Z */
/* Digito: 0-9 */
/* Identificador: Acepta letras o guion bajo al inicio, luego letras, digitos o guion bajo */

DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       [_a-zA-Z][_a-zA-Z0-9]*

%%

{ID}        { printf("IDENTIFICADOR VALIDO: %s\n", yytext); }
[ \t\n]+    ; /* Ignorar espacios en blanco */
.           { printf("NO VALIDO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
