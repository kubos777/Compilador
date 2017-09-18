
%{
/*
Programa que reconoce componentes léxicos definidos en clase*/

	
	/*Arreglos para definir las clases y tablas estáticas.*/

	char* op_arit[] = {
		"DIVIDE",
		"MAS",
		"MENOS",
		"MULTIPLICA"
	};

	char* op_rel[] = {
		">",
		">=",
		"<",
		"<=",
		"==",
		"!="
	};

	char* pal_res[] = {
		"ENT",
		"ESCRIBE",
		"HAZ",
		"LEE",
		"MIENTRAS",
		"REAL",
		"SI",
		"SINO"
	};

	int buscaValor(char** tabla,char* valor) {
		int i = 0;
		while (strcmp(valor,tabla[i]) != 0) {
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

	token_t* lista_token;

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
		nueva_cadena->valor = valor;
		nueva_cadena->siguiente = NULL;
		return nueva_cadena;
	}

	//Crea una entrada en la tabla de símbolos (identificadores)
	simbolo_t* crearSimbolo(int clave, char* valor) {
		simbolo_t* nuevo_simbolo = malloc(sizeof(simbolo_t));

		if (nuevo_simbolo == NULL) {
			return NULL;
		}
		nuevo_simbolo->clave = clave;
		nuevo_simbolo->valor = valor;
		nuevo_simbolo->siguiente = NULL;
		return nuevo_simbolo;
	}

	//Inserta un token en la lista de tokens
	void insertarToken(token_t* tabla_token, int clase, float valor) {
		token_t* aux = tabla_token;
		if (tabla_token->clase == -1) {
			tabla_token->clase = clase;
			tabla_token->valor = valor;
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
		if (tabla_cadena->clave == -1) {
			tabla_cadena->clave = clave;
			tabla_cadena->valor = valor;
		}
		else {
			while(aux->siguiente != NULL) {
				aux = aux->siguiente;
			}
			aux->siguiente = crearCadena(clave,valor);
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

	//Busca si una cadena existe en la tabla de cadenas, 
	//si existe, devuelve la clave de ésta
	//en caso contrario, devuelve el valor de -1
	int buscarCadena(cadena_t* tabla_cadena,char* cadena) {
		cadena_t* aux = tabla_cadena;
		while(aux != NULL) {
			if (strcmp(aux->valor,cadena) == 0) {
				return aux->clave;
			}
			aux = aux->siguiente;
		}
		return -1;
	}

	//Busca si un símbolo existe en la tabla de símbolos,
	//si existe, devuelve la clave de éste
	//en caso contrario, devuelve el valor de -1
	int buscarSimbolo(simbolo_t* tabla_simbolo,char* simbolo) {
		simbolo_t* aux = tabla_simbolo;
		while(aux != NULL) {
			if (strcmp(aux->valor,simbolo) == 0) {
				return aux->clave;
			}
			aux = aux->siguiente;
		}
		return -1;
	}

	//Imprime la lista de tokens en pantalla
	void imprimirTokens(token_t* tabla_token) {
		token_t* aux = tabla_token;
		printf("%8s%8s\n", "Clase","Valor");
		while(aux != NULL) {
			if((aux->valor)/(int)(aux->valor) == 1 ) {
				printf("%8d%10.0f\n",aux->clase,aux->valor);
			}
			else {
				printf("%8d%10f\n",aux->clase,aux->valor);
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

%}

opArit MAS|MENOS|MULTIPLICA|DIVIDE
palRes ENT|REAL|SI|SINO|MIENTRAS|HASTA|ESCRIBE|LEE
opAsig =
let [a-zA-Z_]
dig [1-9]
ident {let}({let}|{dig}|0){0,15}
simbEsp [,;\[\]\(\)]
entBD {dig}({dig}|0)*
numReal {entBD}\.[0-9]+
constCad \"[^\"]+\"
blank [ \t]


%%
{opArit} {printf("%s es un operador aritmetico.\n",yytext);
			insertarToken(lista_token,4,(float)buscaValor(op_arit,yytext));
			}
{palRes} {printf("%s es una palabra reservada.\n",yytext);
			insertarToken(lista_token,1,(float)buscaValor(pal_res,yytext));}
{opAsig} {printf("%s es un operador de asignacion.\n",yytext);
			insertarToken(lista_token,2,(float)'=');}
{ident} {printf("%s es un identificador.\n",yytext);}
{entBD} {printf("%s es un entero en base diez.\n",yytext);
			insertarToken(lista_token,6,atof(yytext));}
{constCad} {printf("%s es una constante cadena.\n",yytext);}
{simbEsp} {printf("%s es un simbolo especial.\n",yytext);
			insertarToken(lista_token,5,(float)yytext[0]);}
{numReal} {printf("%s es un numero real.\n",yytext);
			insertarToken(lista_token,7,atof(yytext));}
{blank} {/*No hace nada*/}
. {printf("Error %s no es nada\n",yytext);}

%%



int main(int argc,char *argv[]){
lista_token = crearTablaTokens();
yyin=fopen(argv[1],"r");
yylex();
fclose(yyin);
imprimirTokens(lista_token);
return 0;
}
