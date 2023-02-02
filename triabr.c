#include"header.h"

typedef struct ABR{
	char val[255];
	int count;
	struct ABR* fg;
	struct ABR* fd;
}ABR;

ABR* createABR(char e[255]){
	ABR* a;
	a =(ABR*)malloc(sizeof(ABR));
	strcpy(a->val, e);
	a->count=1;
	a->fg=NULL;
	a->fd=NULL;
	return a;
}

ABR* insertABR (ABR* a, char e[255]){
	if (a==NULL){
		return createABR(e);
	}
	if (strcmp(e,a->val)<0){
		a->fg = insertABR(a->fg,e);
	}
	else if (strcmp(e,a->val)>0){
		a->fd = insertABR(a->fd,e);
	}
	else {
		a->count=a->count+1;
		return a;
	}
	return a;
}

void printABR(ABR* a, FILE *file){
	if (a != NULL){
		printABR(a->fg, file);
		for (int i=0;i<a->count;i++){
			fprintf(file, "%s", a->val);
		}
		printABR(a->fd, file);
		free(a);
		
	}
}

void printABR_reverse(ABR* a, FILE *file){
	if (a != NULL){
		printABR_reverse(a->fd, file);
		for (int i=0;i<a->count;i++){
			fprintf(file, "%s", a->val);
		}
		printABR_reverse(a->fg, file);
		free(a);
		
	}
}
