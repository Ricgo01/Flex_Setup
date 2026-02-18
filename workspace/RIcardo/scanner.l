%{
    /* SECCION 1: DEFINICIONES DE C */
    /* Aquí incluimos librerías y cualquier código C necesario antes del análisis */
#include <stdio.h>
%}

/* SECCION 2: DEFINICIONES DE FLEX */
/* Aquí creamos alias para expresiones regulares complejas y estados exclusivos */

/* Definiciones básicas */
DIGIT       [0-9]
HEXDIGIT    [0-9a-fA-F]

/* Estado exclusivo para manejar comentarios de bloque */
%x B_COMMENT

/* Alias para patrones complejos */
HEX         0[xX]{HEXDIGIT}+
SCIENTIFIC  ({DIGIT}+(\.{DIGIT}*)?|\.{DIGIT}+)[eE][+-]?{DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
INTEGER     {DIGIT}+
ID          [_a-zA-Z][_a-zA-Z0-9]*
STRING      \"(\\.|[^"\\])*\"

%%

/* SECCION 3: REGLAS DE ANÁLISIS */
/* Aquí definimos qué hacer cuando encontramos cada patrón */

    /* Comentarios: Los ignoramos para limpiar el input */
"//".*              ; 
"/*"                { BEGIN(B_COMMENT); }
<B_COMMENT>"*/"     { BEGIN(INITIAL); }
<B_COMMENT>.|\n     ;

    /* Cadenas y Operadores: Identificamos literales de texto y símbolos matemáticos/lógicos */
{STRING}                        { printf("LITERAL_CADENA: %s\n", yytext); }
"+"|"-"|"*"|"/"                 { printf("OP_ARITMETICO: %s\n", yytext); }
"="                             { printf("OP_ASIGNACION: %s\n", yytext); }
"=="|"!="|"<="|">="|"<"|">"     { printf("OP_RELACIONAL: %s\n", yytext); }
"&&"|"||"|"!"                   { printf("OP_LOGICO: %s\n", yytext); }

    /* Números e Identificadores: Clasificamos los diferentes tipos numéricos y variables */
{HEX}               { printf("HEXADECIMAL: %s\n", yytext); }
{SCIENTIFIC}        { printf("NOTACION CIENTIFICA: %s\n", yytext); }
{FLOAT}             { printf("FLOTANTE: %s\n", yytext); }
{INTEGER}           { printf("ENTERO: %s\n", yytext); }
{ID}                { printf("IDENTIFICADOR VALIDO: %s\n", yytext); }

    /* Otros: Ignoramos espacios en blanco y reportamos errores */
[ \t\n]+            ; 
.                   { printf("NO RECONOCIDO: %s\n", yytext); }

%%

/* SECCION 4: CÓDIGO DE USUARIO */
/* Aquí va el punto de entrada (main) que inicia el análisis léxico */
int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
