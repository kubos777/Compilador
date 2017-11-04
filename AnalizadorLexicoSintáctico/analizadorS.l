
%{
/*
Programa que reconoce componentes léxicos definidos en clase.
Analizador realizado por: 
						Chávez Delgado Jorge Luis
						Sánchez Neri David Yaxkin */
	
	/**********************************************************

					ANALIZADOR LEXICO

	**********************************************************/


	/*Arreglos para definir las clases y tablas estáticas.*/

	char* op_arit[][2] = {
		{ "DIVIDE",		"/" },
		{ "MAS",		"+" },
		{ "MENOS",		"-" },
		{ "MULTIPLICA",	"*" }
	};

	char* op_rel[][2] = {
		{ ">",	">" },
		{ ">=", "g" },
		{ "<", 	"<" },
		{ "<=", "p" },
		{ "==", "q" },
		{ "!=", "!" }
	};

	char* pal_res[][2] = {
		{ "ENT", 		"t" },
		{ "ESCRIBE", 	"w" },
		{ "HAZ", 		"h" },
		{ "LEE", 		"l" },
		{ "MIENTRAS",	"m" },
		{ "REAL", 		"r" },
		{ "SI", 		"i" },
		{ "SINO", 		"e" },
	};

	int buscaValor(char* tabla[][2],char* valor) {
		int i = 0;
		while (strcmp(valor,tabla[i][0]) != 0) {
			i++;
		}
		return i;
	}

	/*
		Estructuras de datos (listas ligadas) para el manejo de los tokens, 
		así como las tablas de símbolos y cadenas.
	*/

	//Estructura para almacenar un token 
	typedef struct token {
		int clase;
		float valor;
		char* tipo;
		struct token* siguiente;
	}token_t;

	//Estructura para almacenar una cadena
	typedef struct entr_cadena {
		int clave;
		char* valor;
		struct entr_cadena* siguiente;
	}cadena_t;

	//Estructura para almacenar una simbolo (identificador)
	typedef struct entr_simbolo {
		int clave;
		char* valor;
		struct entr_simbolo* siguiente;
	}simbolo_t;

	/*Declaramos los apuntadores a las tablas/listas, y contadores*/

	token_t* lista_token;
	cadena_t* tabla_cadenas;
	simbolo_t* tabla_simbolos;
	int num_cadenas = 0;
	int num_id = 0;

	//Crea la lista ligada que almacenará los tokens
	token_t* crearTablaTokens() {
		token_t* inicio = NULL;
		inicio = malloc(sizeof(token_t));
		if (inicio == NULL) {
			return NULL;
		}
		inicio->siguiente = NULL;
		inicio->clase = -1;
		return inicio;
	}

	//Crea la lista ligada que almacenará la tabla de cadenas
	cadena_t* crearTablaCadenas() {
		cadena_t* inicio = NULL;
		inicio = malloc(sizeof(cadena_t));
		if (inicio == NULL) {
			return NULL;
		}
		inicio->siguiente = NULL;
		inicio->clave = -1;
		return inicio;
	}

	//Crea la lista ligada que almacenará la tabla de cadenas
	simbolo_t* crearTablaSimbolos() {
		simbolo_t* inicio = NULL;
		inicio = malloc(sizeof(simbolo_t));
		if (inicio == NULL) {
			return NULL;
		}
		inicio->siguiente = NULL;
		inicio->clave = -1;
		return inicio;
	}

	//Crea un token con sus valores correspondientes de clase y valor
	token_t* crearToken(int clase, float valor) {
		token_t* nuevo_token = malloc(sizeof(token_t));
		if (nuevo_token == NULL) {
			return NULL;
		}
		nuevo_token->clase = clase;
		nuevo_token->valor = valor;
		nuevo_token->tipo = malloc(sizeof(char*)+1);
		strcpy(nuevo_token->tipo,"");
		nuevo_token->siguiente = NULL;
		return nuevo_token;
	}

	//Crea una entrada en la tabla de cadenas
	cadena_t* crearCadena(int clave, char* valor) {
		cadena_t* nueva_cadena = malloc(sizeof(cadena_t));
		char* aux_valor = malloc(sizeof(valor));
		strcpy(aux_valor,valor);
		if (nueva_cadena == NULL) {
			return NULL;
		}
		nueva_cadena->clave = clave;
		nueva_cadena->valor = aux_valor;
		nueva_cadena->siguiente = NULL;
		return nueva_cadena;
	}

	//Crea una entrada en la tabla de símbolos (identificadores)
	simbolo_t* crearSimbolo(int clave, char* valor) {
		simbolo_t* nuevo_simbolo = malloc(sizeof(simbolo_t));
		char* aux_valor = malloc(sizeof(valor));
		strcpy(aux_valor,valor);
		if (nuevo_simbolo == NULL) {
			return NULL;
		}
		nuevo_simbolo->clave = clave;
		nuevo_simbolo->valor = aux_valor;
		nuevo_simbolo->siguiente = NULL;
		return nuevo_simbolo;
	}

	//Inserta un token en la lista de tokens
	void insertarToken(token_t* tabla_token, int clase, float valor) {
		token_t* aux = tabla_token;
		if (tabla_token->clase == -1) {
			tabla_token->clase = clase;
			tabla_token->valor = valor;
			tabla_token->tipo = malloc(sizeof(char*)+1);
			strcpy(tabla_token->tipo,"");
		}
		else {
			while(aux->siguiente != NULL) {
				aux = aux->siguiente;
			}
			aux->siguiente = crearToken(clase,valor);
		}
	}

	//Inserta una cadena en la tabla de cadenas
	void insertarCadena(cadena_t* tabla_cadena, int clave, char* valor) {
		cadena_t* aux = tabla_cadena;
		char* aux_valor = malloc(sizeof(valor));
		strcpy(aux_valor,valor);
		if (tabla_cadena->clave == -1) {
			tabla_cadena->clave = clave;
			tabla_cadena->valor = aux_valor;
		}
		else {
			while(aux->siguiente != NULL) {
				aux = aux->siguiente;
			}
			aux->siguiente = crearCadena(clave,aux_valor);
		}
	}

	//Inserta un simbolo en la tabla de simbolos
	void insertarSimbolo(simbolo_t* tabla_simbolo, int clave, char* valor) {
		simbolo_t* aux = tabla_simbolo;
		char* aux_valor = malloc(sizeof(valor));
		strcpy(aux_valor,valor);
		if (tabla_simbolo->clave == -1) {
			tabla_simbolo->clave = clave;
			tabla_simbolo->valor = aux_valor;
		}
		else {
			while(aux->siguiente != NULL) {
				aux = aux->siguiente;
			}
			aux->siguiente = crearSimbolo(clave,aux_valor);
		}
	}

	//Busca si un símbolo existe en la tabla de símbolos, si existe, devuelve la clave de éste en caso contrario, devuelve el valor de -1
	int buscarSimbolo(simbolo_t* tabla_simbolo,char* simbolo) {
		simbolo_t* aux = tabla_simbolo;
		char* aux_simbolo = malloc(sizeof(simbolo)+1);
		strcpy(aux_simbolo,simbolo);
		
		while(aux != NULL) {
			if (aux->valor != NULL && strcmp(aux->valor,aux_simbolo) == 0) {
				return (aux->clave);
			}
			
			aux = aux->siguiente;
		}
		return -1;
	}

	//Imprime la lista de tokens en pantalla
	void imprimirTokens(token_t* tabla_token) {
		token_t* aux = tabla_token;
		printf("%8s%10s%10s\n", "Clase","Valor","Tipo");
		while(aux != NULL) {
			if((aux->valor) - (int)(aux->valor) == 0 ) {
				printf("%8d%10.0f%10s\n",aux->clase,aux->valor,aux->tipo);
			}
			else {
				printf("%8d%10f%10s\n",aux->clase,aux->valor,aux->tipo);
			}
			aux = aux->siguiente;
		}
	}

	//Imprime la tabla de cadenas en pantalla
	void imprimirCadenas(cadena_t* tabla_cadena) {
		cadena_t* aux = tabla_cadena;
		printf("%8s%40s\n", "Clave","Valor");
		while(aux != NULL) {
			printf("%8d%40s\n",aux->clave,aux->valor);
			aux = aux->siguiente;
		}
	}

	//Imprime la tabla de símbolos en pantalla
	void imprimirSimbolos(simbolo_t* tabla_simbolo) {
		simbolo_t* aux = tabla_simbolo;
		printf("%8s%40s\n", "Clave","Valor");
		while(aux != NULL) {
			printf("%8d%40s\n",aux->clave,aux->valor);
			aux = aux->siguiente;
		}
	}


	/**********************************************************

					ANALIZADOR SINTACTICO

	**********************************************************/

	//Código para crear la cadena que servirá para el análisis sintáctico descendente
	char* cadena;
	char c;
	char buffer[1];
	int iterador = 0;
	int var_error = 0;

	//Prototipos de las funciones del parser
	void parser();
	void P();
	void LF();
	void FUN();
	void LA();
	void LAP();
	void LD();
	void D();
	void V();
	void C();
	void N();
	void L();
	void BP();
	void PR();
	void S();
	void PC();
	void A();
	void W();
	void WP();
	void WPP();
	void R();
	void RP();
	void H();
	void M();
	void I();
	void REL();
	void OR();
	void LP();
	void LPA();
	void E();
	void EP();
	void T();
	void TP();
	void F();
	void error();


	//Definiciones de las funciones del parser recursivo descendente 

	void parser(){
		c=cadena[iterador++];
		P();
		if (buffer=='\0' || var_error == 0)
		{
			printf("\nEl programa no presenta errores sintácticos.\n");
		}
		else{
			printf("\nEl programa contiene errores sintácticos.\n");
		}
	}
	void P() {
		if (c == 't' || c == 'r' || c == 'a') {
			LF();
			return;
		}
		else {
			error();
		}
	}
	void LF() {
		if (c == '\0') {
			return;
		}
		else if (c == 't' || c == 'r' || c == 'a') {
			FUN();
			LF();
		}
		else {
			return;
		}
	}
	void FUN() {
		if(c == 't' || c == 'r') {
			V();
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == '(') { 
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LA();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == '[') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LD();
			BP();
			if (c == ']') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else if (c == 'a') {
			c = cadena[iterador++];
			if (c == '(') { 
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LA();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == '[') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LD();
			BP();
			if (c == ']') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else {
			error();
			return;
		}
	}
	void LA() {
		if (c == ')') {
			return;
		}
		else if(c == 't' || c == 'r') {
			V();
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LAP();
		}
		else {
			error();
			return;
		}
	}
	void LAP() {
		if (c == ')') {
			return;
		}
		else if (c == ',') {
			c = cadena[iterador++];
			V();
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LAP();
		}
		else {
			error();
		}
	}
	void LD() {
		if (c == ']' || c == '@' || c == 'a' || c == 'w' || c == 'l' || c == 'h' || c == 'm' || c == 'i' || c == '[') {
			return;
		}
		else if(c == 't' || c == 'r') {
			D();
			LD();
		}
		else {
			error();
		}
	}
	void D() {
		if (c == 't' || c == 'r') {
			V();
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			C();
			L();
		}
		else {
			error();
		}
	}
	void V() {
		if (c == 't' || c == 'r') {
			c = cadena[iterador++];	
			return;
		}
		else {
			error();
		}
	}
	void C() {
		if (c == ',' || c == ';') {
			return;
		}
		else if (c == '=') {
			c = cadena[iterador++];
			N();
		}
		else {
			error();
		}

	}
	void N() {
		if (c == 'n' || c == 'c') {
			c = cadena[iterador++];
			return;
		}
		else {
			error();
		}
	}
	void L() {
		if (c == ',') {
			c = cadena[iterador++];
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			C();
			L();
		}
		else if (c == ';') {
			c = cadena[iterador++];
			return;
		}
		else {
			error();
		}
	}
	void BP() {
		if (c == ']') {
			return;
		}
		else if (c == 'a' || c == 'w' || c == 'l' || c == 'h' || c == 'm' || c == 'i' || c == '[' || c == '@') {
			PR();
			BP();
		}
		else {
			error();
		}
	}
	void PR() {
		if (c == 'a' || c == 'w' || c == 'l' || c == 'h' || c == 'm' || c == 'i' || c == '@') {
			S();
		}
		else if (c == '[') {
			PC();
		}
	}
	void S() {
		if (c == 'a') {
			A();
		}
		else if (c == 'w') {
			W();
		}
		else if (c == 'l') {
			R();
		}
		else if (c == 'h') {
			H();
		}
		else if (c == 'm') {
			M();
		}
		else if (c == 'i') {
			I();
		}
		else if (c == '@') {
			c = cadena[iterador++];
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == '(') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LP();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == ';') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else {
			error();
		}
	}
	void PC() {
		if (c == '[') {
			c = cadena[iterador++];
			BP();
			if (c == ']') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else {
			error();
		}
	}
	void A() {
		if (c == 'a') {
			c = cadena[iterador++];
			if (c == '=') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			E();
			if (c == ';') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else {
			error();
		}
	}
	void W() {
		if (c == 'w') {
			c = cadena[iterador++];
			WP();
		}
		else {
			error();
		}
	}
	void WP() {
		if (c == 'a' || c == 'c' || c == 'n' || c == 's') {
			c = cadena[iterador++];
			WPP();
		}
		else {
			error();
		}
	}
	void WPP() {
		if (c == ',') {
			c = cadena[iterador++];
			WP();
		}
		else if (c == ';') {
			c = cadena[iterador++];
			return;
		}
		else {
			error();
		}
	}
	void R() {
		if (c == 'l') {
			c = cadena[iterador++];
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			RP();
		}
		else {
			error();
		}
	}
	void RP() {
		if (c == ',') {
			c = cadena[iterador++];
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			RP();
		}
		else if (c == ';') {
			c = cadena[iterador++];
			return;
		}
		else {
			error();
		}
	}
	void H() {
		if (c == 'h') {
			c = cadena[iterador++];	
			if (c == '[') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			BP();
			if (c == ']') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == 'm') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == '(') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			REL();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else {
			error();
		}
	}
	void M() {
		if (c == 'm') {
			c = cadena[iterador++];
			if (c == '(') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			REL();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			PR();
		}
		else {
			error();
		}
	}
	void I() {
		if (c == 'i') {
			c = cadena[iterador++];
			if (c == '(') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			REL();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			PR();
			if (c == 'e') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			PR();
		}
		else {
			error();
		}
	}
	void REL() {
		if (c == '(' || c == 'a' || c == 'n' || c == 'c' || c == '@') {
			E();
			OR();
			E();
		}
		else {
			error();
		}
	}
	void OR() {
		if (c == '>' || c == 'g' || c == '<' || c == 'p' || c == 'q' || c == '!' ) {
			c = cadena[iterador++];
		}
		else {
			error();
		}
	}
	void LP() {
		if (c == '(' || c == 'a' || c == 'n' || c == 'c' || c == '@') {
			E();
			LPA();
		}
		else if (c == ')') {
			return;
		}
		else {
			error();
		}
	}
	void LPA() {
		if (c == ')') {
			return;
		}
		else if(c == ',') {
			c = cadena[iterador++];
			E();
			LPA();
		}
		else {
			error();
		}
	}
	void E() {
		if (c == '(' || c == 'a' || c == 'n' || c == 'c' || c == '@') {
			T();
			EP();
		}
		else {
			error();
		}
	}
	void EP() {
 		if (c == '+' || c == '-') {
 			c = cadena[iterador++];
 			T();
 			EP();
 		}
 		else if (c == ',' || c == ';' || c == ')' || c == '>' || c == 'g' || c == '<' || c == 'p' || c == 'q' || c == '!') {
			return;
 		}
 		else {
 			error();
 		}
	}
	void T() {
		if (c == '(' || c == 'a' || c == 'n' || c == 'c' || c == '@') {
			F();
			TP();
		}
		else {
			error();
		}
	}
	void TP() {
 		if (c == '*' || c == '/') {
 			c = cadena[iterador++];
 			F();
 			TP();
 		}
 		else if (c == '+' || c == '-' || c == ';' || c == ')' || c == '>' || 
 				c == 'g' || c == '<' || c == 'p' || c == 'q' || c == '!' || c == ',') {
			return;
 		}
 		else {
 			error();
 		}
	}
	void F() {
		if (c == 'a' || c == 'n' || c == 'c') {
			c = cadena[iterador++];
		}
		else if (c == '@') {
			c = cadena[iterador++];
			if (c == 'a') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			if (c == '(') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
			LP();
			if (c == ')') {
				c = cadena[iterador++];
			}
			else {
				error();
			}
		}
		else if (c == '(') {
			c = cadena[iterador++];	
			E();
			if (c == ')') {
				c = cadena[iterador++];	
			}
			else {
				error();
			}
		}
		else {
			error();
		}
	}
	void error() {
		printf("Error sintáctico en el caracter %i de la cadena de átomos: %c\n", iterador, cadena[iterador-1]);
		var_error = 1;
	}

%}

opArit MAS|MENOS|MULTIPLICA|DIVIDE
palRes ENT|REAL|SI|SINO|HAZ|MIENTRAS|HASTA|ESCRIBE|LEE
opRel (<|>|!|=)=|<|>
opAsig =
let [a-z]
dig [1-9]
ident {let}({let}|{dig}|0){0,15}
simbEsp [,;\[\]\(\)@]
entBD (0|{dig}){dig}*
numReal {entBD}\.[0-9]+
constCad \"[^\"]+\"
comentario \$\$[^\$\n]+
blank [ \t\n]


%%
{opArit} 	{printf("%s es un operador aritmetico.\n",yytext);
			insertarToken(lista_token,4,(float)buscaValor(op_arit,yytext));
			buffer[0] = op_arit[buscaValor(op_arit,yytext)][1][0];
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{opRel}		{printf("%s es un operador aritmetico.\n",yytext);
			insertarToken(lista_token,3,(float)buscaValor(op_rel,yytext));
			buffer[0] = op_rel[buscaValor(op_rel,yytext)][1][0];
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{palRes} 	{printf("%s es una palabra reservada.\n",yytext);
			insertarToken(lista_token,1,(float)buscaValor(pal_res,yytext));
			buffer[0] = pal_res[buscaValor(pal_res,yytext)][1][0];
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{opAsig} 	{printf("%s es un operador de asignacion.\n",yytext);
			insertarToken(lista_token,2,(float)'=');
			buffer[0] = '=';
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{ident} 	{printf("%s es un identificador.\n",yytext);
				if(buscarSimbolo(tabla_simbolos,yytext) == -1) {
					insertarSimbolo(tabla_simbolos,num_id++,yytext);
				}
			insertarToken(lista_token,0,buscarSimbolo(tabla_simbolos,yytext));
			buffer[0] = 'a';
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);}
{entBD} 	{printf("%s es un entero en base diez.\n",yytext);
			insertarToken(lista_token,6,atof(yytext));
			buffer[0] = 'c';
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{constCad} 	{printf("%s es una constante cadena.\n",yytext);
			insertarCadena(tabla_cadenas,num_cadenas,yytext);
			insertarToken(lista_token,8,(float)num_cadenas++);
			buffer[0] = 's';
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{simbEsp} 	{printf("%s es un simbolo especial.\n",yytext);
			insertarToken(lista_token,5,(float)yytext[0]);
			buffer[0] = yytext[0];
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{numReal} 	{printf("%s es un numero real.\n",yytext);
			insertarToken(lista_token,7,atof(yytext));
			buffer[0] = 'n';
			cadena = realloc(cadena,(strlen(cadena)+2)*sizeof(char));
			strncat(cadena,buffer,1);
			}
{blank} 	{/*No hace nada*/}
{comentario} {/*No hace nada*/}
. 			{printf("Error %s no es nada\n",yytext);}

%%

int main(int argc,char *argv[]){
lista_token = crearTablaTokens();
tabla_simbolos = crearTablaSimbolos();
tabla_cadenas = crearTablaCadenas();
cadena = (char*)malloc(sizeof(char));
yyin=fopen(argv[1],"r");
yylex();
fclose(yyin);
imprimirCadenas(tabla_cadenas);	
imprimirSimbolos(tabla_simbolos);
imprimirTokens(lista_token);
printf("La cadena de átomos correspondiente al programa analizado es:\n%s\n",cadena);
parser();
return 0;
}
