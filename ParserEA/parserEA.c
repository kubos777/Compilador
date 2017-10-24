#include <stdio.h>
/*PROTOTIPOS DE LAS FUNCIONES DE LAS REGLAS DE PRODUCCIÓN*/
void  E();
void EP();
void T();
void TP();
void F();
void parser();


char *c=NULL;
int iterador=0;
char buffer;

int main(int argc, char const *argv[])
{
	/*Leemos la cadena */
	printf("\nIngresa la cadena a analizar: ");
	scanf("%m[^\n]s",&c); //Guardamos la cadena de manera dinámica
	printf("%s\n\n",c );
	parser();
	return 0;
}





/*DEFINICIONES DE LAS FUNCIONES DE LAS REGLAS DE PRODUCCIÓN*/

void parser(){
	buffer=c[iterador];
	iterador++;
	//E();
	if (buffer=='\n')
	{
		printf("\nLa cadena se acepta.\n");
	}
	else{
		printf("\nError, la cadena no es válida...\n");
	}
}

