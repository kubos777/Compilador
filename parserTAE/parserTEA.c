//Chávez Delgado Jorge Luis		Compiladores  Grupo:02

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define p printf
/*PROTOTIPOS DE LAS FUNCIONES DE LAS REGLAS DE PRODUCCIÓN*/
//El átomo para identificadores es a
void E(); 
void EP();
void T();
void TP();
void F();
void parser();
//Variables
char *c=NULL; //Apuntador dónde se almacenará la cadena ingresada por el usuario
char *t=NULL; //Apuntador para almacenar la cadena traducida
int iterador=0; //Nos ayudará a recorrer la cadena
int contador=0;
char buffer; // Auxiliar para almacenar y comparar el caracter
int error = 0; //Para capturar los errores, es 0 sí no hubo error y 1 sí existe error

int main(int argc, char const *argv[])
{

	p("╔═╗┌┐┌┌─┐┬  ┬┌─┐┌─┐┌┬┐┌─┐┬─┐  ┌─┐┬┌┐┌┌┬┐┌─┐┌─┐┌┬┐┬┌─┐┌─┐  ┌┬┐┌─┐\n");
	p("╠═╣│││├─┤│  │┌─┘├─┤ │││ │├┬┘  └─┐││││ │ ├─┤│   │ ││  │ │   ││├┤ \n");
	p("╩ ╩┘└┘┴ ┴┴─┘┴└─┘┴ ┴─┴┘└─┘┴└─  └─┘┴┘└┘ ┴ ┴ ┴└─┘ ┴ ┴└─┘└─┘  ─┴┘└─┘\n");
	p("╔═╗─┐ ┬┌─┐┬─┐┌─┐┌─┐┬┌─┐┌┐┌┌─┐┌─┐  ┌─┐┬─┐┬┌┬┐┌┬┐┌─┐┌┬┐┬┌─┐┌─┐┌─┐\n");
	p("║╣ ┌┴┬┘├─┘├┬┘├┤ └─┐││ ││││├┤ └─┐  ├─┤├┬┘│ │ │││├┤  │ ││  ├─┤└─┐\n");
	p("╚═╝┴ └─┴  ┴└─└─┘└─┘┴└─┘┘└┘└─┘└─┘  ┴ ┴┴└─┴ ┴ ┴ ┴└─┘ ┴ ┴└─┘┴ ┴└─┘\n");
	p("┌─┐┌─┐┌┐┌  ┌┬┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌─┐┬┌─┐┌┐┌  ┌─┐\n");
	p("│  │ ││││   │ ├┬┘├─┤ │││ ││  │  ││ ││││  ├─┤ \n");
	p("└─┘└─┘┘└┘   ┴ ┴└─┴ ┴─┴┘└─┘└─┘└─┘┴└─┘┘└┘  ┴ ┴ \n");
	p("┌┐┌┌─┐┌┬┐┌─┐┌─┐┬┌─┐┌┐┌  ┌─┐┌─┐┌─┐┌─┐┬ ┬┌─┐\n");
	p("││││ │ │ ├─┤│  ││ ││││  ├─┘│ │└─┐├┤ │ │├─┤\n");
	p("┘└┘└─┘ ┴ ┴ ┴└─┘┴└─┘┘└┘  ┴  └─┘└─┘└  ┴└┘┴ ┴\n");


	/*Leemos la cadena que se va a analizar*/
	p("\nIngresa la cadena que deseas analizar: ");
	scanf("%m[^\n]s",&c); //Guardamos la cadena de manera dinámica
	t = malloc(sizeof(char)*strlen(c));
	parser(); // Llamamos a la función parser
	return 0;
}

/*DEFINICIONES DE LAS FUNCIONES DE LAS REGLAS DE PRODUCCIÓN*/

void parser(){
	buffer=c[iterador]; //buffer dónde se almacenará el caracter a analizar
	iterador++; //Nos ayuda a recorrer la cadena.
	E();
	if (buffer=='\0' && error == 0)
	{
		p("\nEl analizador ha aceptado tu cadena.\n");
		p("\nLa salida de tu cadena en notación posfija es: %s\n\n",t);
	}
	else{
		p("\nLo siento, la cadena que ingresaste no es válida.\n");
	}
}

void E() {
	//Verificamos si hay parentesis que abre o identificador
	if (buffer == '(' || buffer == 'a') {
		T();
		EP();	
		return;
	}
	else {
		error = 1;
		return;
	}
}

void EP() {

	//Verificamos si existe operador para la suma o resta
	if (buffer == '+') {
		buffer=c[iterador++];
		T();
		t[contador]='+';
		contador++;  //Si existe el operador + se escribe ya que es símbolo de acción
		EP();
		return;
	}
	else if (buffer == '-') {
		buffer=c[iterador++];
		T();
		t[contador]='-'; //Si existe el operador - se escribe ya que es símbolo de acción
		contador++;
		EP();
		return;
	}
	//Verificamos si se cierra el parentesis que abrió
	else if (buffer == '\0' || buffer == ')') {
		return;
	}
	else {
		error = 1;
		return;
	}
}

void T() {
	//Verificamos si hay parentesis que abre o identificador
	if (buffer == '(' || buffer == 'a') {
		F();
		TP();
		return;
	}	
	else {
		error = 1;
		return;
	}
}

void TP() {
	//Verificamos si existe operador para la multiplicación o división
	if (buffer == '*') {
		buffer=c[iterador++];
		F();
		t[contador]='*'; //Si existe el operador  * se escribe ya que es símbolo de acción
		contador++;
		TP();
		return;
	}
	else if (buffer == '/') {
		buffer=c[iterador++];
		F();
		t[contador]='/'; //Si existe el operador / se escribe ya que es símbolo de acción
		contador++;
		TP();
		return;
	}
	//Verificamos si hay más operadores o sí se cierra algún parentesis antes abierto	
	else if (buffer == '\0' || buffer == '+' || buffer == '-' || buffer == ')') {
		return;
	}
	else {
		error = 1;
		return;
	}
}
void F() {
	//Verificamos si hay parentesis que abre	
	if (buffer == '(') {
		buffer=c[iterador++];
		E();
		//Verificamos si hay parentesis que cierra
		if(buffer == ')') {
			buffer=c[iterador++];
			return;
		}
		else {
			error = 1;
			return;
		}
	}
	////Verificamos si es identificador
	else if (buffer == 'a') {
		buffer=c[iterador++];
		t[contador]='a'; //Si existe el identificador se escribe ya que es símbolo de acción
		contador++;
		return;
	}
	else {
		error = 1;
		return;
	}
}
