%{
/*
 * Archivo: scanner.l
 * Descripción: Lexer combinado que integra:
 *   - Identificadores Java (letra/guion bajo -> letras/dígitos/guion bajo)
 *   - Literales Numéricos (Enteros, Flotantes, Científicos, Hexadecimales)
 *   - Cadenas Literales (entre comillas dobles con escapes)
 *   - Operadores (Aritméticos, Relacionales, Lógicos)
 *   - Comentarios (Línea // y Bloque)
 *
 *   NOTA: NO HAY palabras reservadas, todas se detectan como identificadores simples.
 *
 * Compilación:
 *    flex scanner.l
 *    gcc lex.yy.c -o scanner
 *    ./scanner
 */

#include <stdio.h>
%}

/* Definiciones */
DIGIT       [0-9]
HEXDIGIT    [0-9a-fA-F]

/* Declaración de estado para comentarios de bloque */
%x B_COMMENT

/* Patrones Numéricos */
HEX         0[xX]{HEXDIGIT}+
SCIENTIFIC  ({DIGIT}+(\.{DIGIT}*)?|\.{DIGIT}+)[eE][+-]?{DIGIT}+
FLOAT       {DIGIT}+\.{DIGIT}+
INTEGER     {DIGIT}+

/* Patrón para Identificadores (Java style) */
ID          [_a-zA-Z][_a-zA-Z0-9]*

/* Patrón para String */
STRING      \"(\\.|[^"\\])*\"

%%

    /* --- COMENTARIOS (Ignorados) --- */
"//".*          ; 
"/*"            { BEGIN(B_COMMENT); }
<B_COMMENT>"*/" { BEGIN(INITIAL); }
<B_COMMENT>\n   ; 
<B_COMMENT>.    ; 

    /* --- CADENAS DE TEXTO --- */
{STRING}        { printf("LITERAL_CADENA: %s\n", yytext); }

    /* --- OPERADORES --- */
    /* Aritméticos */
"+"             { printf("OP_ARITMETICO: %s\n", yytext); }
"-"             { printf("OP_ARITMETICO: %s\n", yytext); }
"*"             { printf("OP_ARITMETICO: %s\n", yytext); }
"/"             { printf("OP_ARITMETICO: %s\n", yytext); }

    /* Relacionales y Asignación */
"="             { printf("OP_ASIGNACION: %s\n", yytext); }
"=="            { printf("OP_RELACIONAL: %s\n", yytext); }
"!="            { printf("OP_RELACIONAL: %s\n", yytext); }
"<="            { printf("OP_RELACIONAL: %s\n", yytext); }
">="            { printf("OP_RELACIONAL: %s\n", yytext); }
"<"             { printf("OP_RELACIONAL: %s\n", yytext); }
">"             { printf("OP_RELACIONAL: %s\n", yytext); }

    /* Lógicos */
"&&"            { printf("OP_LOGICO: %s\n", yytext); }
"||"            { printf("OP_LOGICO: %s\n", yytext); }
"!"             { printf("OP_LOGICO: %s\n", yytext); }

    /* --- LITERALES NUMÉRICOS --- */
{HEX}           { printf("HEXADECIMAL: %s\n", yytext); }
{SCIENTIFIC}    { printf("NOTACION CIENTIFICA: %s\n", yytext); }
{FLOAT}         { printf("FLOTANTE: %s\n", yytext); }
{INTEGER}       { printf("ENTERO: %s\n", yytext); }

    /* --- IDENTIFICADORES --- */
    /* Detecta cualquier secuencia de letras/números que empiece con letra o _ */
{ID}            { printf("IDENTIFICADOR VALIDO: %s\n", yytext); }

    /* --- OTROS --- */
[ \t\n]+        ; /* Ignorar espacios */
.               { printf("NO RECONOCIDO: %s\n", yytext); }

%%

int main() {
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}
