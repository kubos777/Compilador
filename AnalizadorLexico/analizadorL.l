%{
/*
Programa que reconoce componentes léxicos definidos en clase*/
%}
opArit [+\-*/%]
opAsig {opArit}?=
let [a-zA-Z_]
dig [1-9]
ident {let}({let}|{dig}|0){0,15}
entBD {dig}({dig}|0)*(u|U)?(L|l)?
%%
{opArit} {printf("%s es un operador aritmetico.\n",yytext);}
{opAsig} {printf("%s es un operador de asignacion.\n",yytext);}
{ident} {printf("%s es un identificador.\n",yytext);}
{entBD} {printf("%s es un entero en base diez.\n",yytext);}
. {printf("Error %s no es nada\n",yytext);}
%%
main(int argc,char *argv[]){
yyin=fopen(argv[1],"r");
yylex();
fclose(yyin);
return 0;
}
