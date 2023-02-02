#include"header.h"

typedef struct Chain{
	char val[255];
	int count;
	struct Chain* next;
}Chain;

Chain* createChain(char e[255]){
	Chain* a;
	a =(Chain*)malloc(sizeof(Chain));
	if (a==NULL){
		exit(1);
	}
	strcpy(a->val, e);
	a->count=1;
	a->next=NULL;
	return a;
}

Chain* insertStart(Chain* a, char e[255]){
	Chain* new=createChain(e);
	new->next=a;
	return new;
}

Chain* insertChain (Chain* a, char e[255]){
	Chain* b=createChain(e);
	Chain* p1=a;
	if (a==NULL){
		a=b;
	}
	else if (strcmp(a->val,e)>0){
		a=insertStart(a,e);
		
	}
	else if (strcmp(a->val,e)<0){
		while(p1->next!=NULL && strcmp(p1->next->val,e)<0){
			//printf("a");
			p1=p1->next;
		}
		if (strcmp(a->val,e)==0){
			a->count=a->count+1;
			return a;
		}
		else if(p1->next==NULL){
			p1->next=b;
		}
		else {
			b->next=p1->next;
			p1->next=b;
		}
	}
	else {
		a->count=a->count+1;
		return a;
	}
	return a;
}

Chain* insertChain_reverse (Chain* a, char e[255]){
	Chain* b=createChain(e);
	Chain* p1=a;
	if (a==NULL){
		a=b;
	}
	else if (strcmp(a->val,e)<0){
		a=insertStart(a,e);
		
	}
	else if (strcmp(a->val,e)>0){
		while(p1->next!=NULL && strcmp(p1->next->val,e)>0){
			//printf("a");
			p1=p1->next;
		}
		if (strcmp(a->val,e)==0){
			a->count=a->count+1;
			return a;
		}
		else if(p1->next==NULL){
			p1->next=b;
		}
		else {
			b->next=p1->next;
			p1->next=b;
		}
	}
	else {
		a->count=a->count+1;
		return a;
	}
	return a;
}

void printChain(Chain* a, FILE *file){
	if (a != NULL){
		for (int i=0;i<a->count;i++){
			fprintf(file, "%s", a->val);
		}
		printChain(a->next, file);
		free(a);
		
	}
}

void printChain_reverse(Chain* a, FILE *file){
	if (a != NULL){
		for (int i=0;i<a->count;i++){
			fprintf(file, "%s", a->val);
		}
		printChain_reverse(a->next, file);
		free(a);
		
	}
}

