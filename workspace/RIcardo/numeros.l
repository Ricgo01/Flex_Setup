%{
/*
 * Archivo: numeros.l
 * Descripción: Reconocedor de literales numéricos, operadores, comentarios y CADENAS:
 *   - Cadenas: "..." con soporte para escapes (\n, \t, \", \\)
 *   - Comentarios: // y /* ... */
 *   - Numéricos: Enteros, Flotantes, Científicos, Hexadecimales
 *   - Aritméticos, Relacionales, Lógicos
 *
 * Compilación:
 *    flex numeros.l
 *    gcc lex.yy.c -o scanner
 *    ./scanner
 */

#include <stdio.h>
%}

/* Definiciones */
DIGIT       [0-9]
HEXDIGIT    [0-9a-fA-F]

/* Declaramos un estado exclusivo para los comentarios de bloque */
%x B_COMMENT

/* Patrones Numéricos */
HEX         0[xX]{HEXDIGIT}+
SCIENTIFIC  ({DIGIT}+(\.{DIGIT}*)?|\.{DIGIT}+)[eE][+-]?{DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
INTEGER     {DIGIT}+

/* Patrón para String:
   Empieza con ", contiene (cualquier cosa escapada OR cualquier cosa que no sea \ ni "), termina con "
*/
STRING      \"(\\.|[^"\\])*\"

%%

    /* Comentarios de una línea */
"//".*          ; 

    /* Comentarios de bloque */
"/*"            { BEGIN(B_COMMENT); }
<B_COMMENT>"*/" { BEGIN(INITIAL); }
<B_COMMENT>\n   ; 
<B_COMMENT>.    ; 

    /* Cadenas de Texto */
{STRING}        { printf("LITERAL_CADENA: %s\n", yytext); }

    /* Operadores Aritméticos */
"+"             { printf("OP_ARITMETICO: %s\n", yytext); }
"-"             { printf("OP_ARITMETICO: %s\n", yytext); }
"*"             { printf("OP_ARITMETICO: %s\n", yytext); }
"/"             { printf("OP_ARITMETICO: %s\n", yytext); }

    /* Operadores Relacionales */
"=="            { printf("OP_RELACIONAL: %s\n", yytext); }
"!="            { printf("OP_RELACIONAL: %s\n", yytext); }
"<="            { printf("OP_RELACIONAL: %s\n", yytext); }
">="            { printf("OP_RELACIONAL: %s\n", yytext); }
"<"             { printf("OP_RELACIONAL: %s\n", yytext); }
">"             { printf("OP_RELACIONAL: %s\n", yytext); }

    /* Operadores Lógicos */
"&&"            { printf("OP_LOGICO: %s\n", yytext); }
"||"            { printf("OP_LOGICO: %s\n", yytext); }
"!"             { printf("OP_LOGICO: %s\n", yytext); }

    /* Literales Numéricos */
{HEX}           { printf("HEXADECIMAL: %s\n", yytext); }
{SCIENTIFIC}    { printf("NOTACION CIENTIFICA: %s\n", yytext); }
{FLOAT}         { printf("FLOTANTE: %s\n", yytext); }
{INTEGER}       { printf("ENTERO: %s\n", yytext); }

    /* Ignorar espacios */
[ \t\n]+        ; 

    /* No reconocidos */
.               { printf("NO RECONOCIDO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
