#include"header.h"

//------------------------[STRUCTURE]----------------------------

typedef struct ABR{
	char val[255];
	int count;
	struct ABR* left;
	struct ABR* right;
}ABR;

//-----------------------[FUNCTIONS]------------------------------

ABR* createABR(char e[255]){
	ABR* a;
	a =(ABR*)malloc(sizeof(ABR));   //Creates the tree
	strcpy(a->val, e);
	a->count = 1;
	a->left = NULL;
	a->right = NULL;
	return a;
}

ABR* insertABR (ABR* a, char e[255]){
	if (a == NULL){
		return createABR(e);
	}
	if (strcmp(e, a->val) < 0){
		a->left = insertABR (a->left, e);
	}
	else if (strcmp(e, a->val) > 0){
		a->right = insertABR (a->right, e);  //Insert the new nodes into an existing tree
	}
	else {
		a->count = a->count + 1;
		return a;
	}
	return a;
}

void printABR (ABR* a, FILE *file){
	if (a != NULL){
		printABR (a->left, file);
		for (int i=0; i < a->count; i++){
			fprintf(file, "%s", a->val);  //Print the sorted tree into the output file
		}
		printABR (a->right, file);
		free(a);
		
	}
}

void printABR_reverse (ABR* a, FILE *file){
	if (a != NULL){
		printABR_reverse (a->right, file);
		for (int i=0; i<a->count; i++){
			fprintf (file, "%s", a->val); //Print the sorted tree this time starting from the biggest value
		}
		printABR_reverse (a->left, file);
		free(a);
		
	}
}
