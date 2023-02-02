#include"header.h"

typedef struct AVL{
	char val[255];
	int balance;
	int count;
	struct AVL* left;
	struct AVL* right;
}AVL;

AVL* createAVL(char e[255]){
	AVL* a;
	a =(AVL*)malloc(sizeof(AVL));
	strcpy(a->val, e);
		a->balance = 0;
		a->count = 1;
		a->left = NULL;
		a->right = NULL;
	return a;
}

AVL* rotation_gauche(AVL* a){
	AVL* pivot = a->right;
	int eq_a = a->balance;
	int eq_p = pivot->balance;
		a->right = pivot->left;
		pivot->left = a;
		a->balance = eq_a-max(eq_p,0)-1;
		pivot->balance = min(min(eq_a-2,eq_a+eq_p-2),eq_p-1);
		a = pivot;
	return a;
}

AVL* rotation_droite(AVL* a){
	AVL* pivot=a->left;
	int eq_a = a->balance;
	int eq_p = pivot->balance;
		a->left = pivot->right;
		pivot->right = a;
		a->balance = eq_a-min(eq_p,0)+1;
		pivot->balance = max(max(eq_a+2,eq_a+eq_p+2),eq_p+1);
		a = pivot;
	return a;
}

AVL* doublerotdroite(AVL* a){
	a->left = rotation_gauche(a->left);
	return rotation_droite(a);
}

AVL* doublerotgauche(AVL* a){
	a->right = rotation_droite(a->right);
	return rotation_gauche(a);
}

AVL* equilibreAVL(AVL *a){
	if (a->balance == 2){
		if (a->right->balance >= 0){
			return rotation_gauche(a);
		}
		else {
			return doublerotgauche(a);
		}
	}
	else if (a->balance == -2){
		if (a->left->balance <= 0){
			return rotation_droite(a);
		}
		else {
			return doublerotdroite(a);
		}
	}
	return a;
}

AVL* insertAVL(AVL* a, char e[255], int* h){
	if (a == NULL){
		*h=1;
		return createAVL(e);
	}
	if (strcmp(e, a->val) < 0){
		a->left = insertAVL(a->left, e, h);
		*h = -*h;
	}
	else if (strcmp(e ,a->val) > 0){
		a->right = insertAVL(a->right, e, h);
	}
	else {
		*h = 0;
		a->count = a->count+1;
		return a;
	}
	if (*h != 0){
		a->balance = a->balance + *h;
		a=equilibreAVL(a);
		if (a->balance == 0){
			*h = 0;
		}
		else {
			*h = 1;
		}
	}
	return a;
}

void printAVL(AVL* a, FILE *file){
	if (a != NULL){
		printAVL(a->left, file);
		for (int i=0;i<a->count;i++){
			fprintf(file, "%s", a->val);
		}
		printAVL(a->right, file);
		free(a);
		
	}
}

void printAVL_reverse(AVL* a, FILE *file){
	if (a != NULL){
		printAVL_reverse(a->right, file);
		for (int i=0;i<a->count;i++){
			fprintf(file, "%s", a->val);
		}		
		printAVL_reverse(a->left, file);
		free(a);
		
	}
}



