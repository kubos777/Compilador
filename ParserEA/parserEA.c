//Chávez Delgado Jorge Luis		Compiladores  Grupo:02

#include <stdio.h>
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
int iterador=0; //Nos ayudará a recorrer la cadena
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

	/*Leemos la cadena que se va a analizar*/
	p("\nIngresa la cadena que deseas analizar: ");
	scanf("%m[^\n]s",&c); //Guardamos la cadena de manera dinámica
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
	if (buffer == '+' || buffer == '-') {
		buffer=c[iterador++];
		T();
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
	if (buffer == '*' || buffer == '/') {
		buffer=c[iterador++];
		F();
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
		return;
	}
	else {
		error = 1;
		return;
	}
}
