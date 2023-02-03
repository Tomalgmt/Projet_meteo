
#include"avl_sort.c"
#include"chain_sort.c"
#include"abr_sort.c"

//--------------------------[CHECK ARGUMENTS]-----------------------------

int main(int argc, char* argv[]){
	int h;
	char line[255];
	if (argc < 3 || argc > 5){
		printf("Command not valid, not enough arguments or too many options\nCommand need to be in form :./executable [input] [output] [options]\nNote that you can put the same output and input but be warned that this will overwrite the file\n");
		return 1;
	}

	if (argc == 5){
		if(!strcmp(arvg[3], argv[4])){
			printf("Error same option put twice\n")
			return 1;
		}
	}

//-------------------------[PRINT FILE]--------------------------------	

	FILE *file = fopen(argv[1],"r");
	if (file == NULL) {
		printf("error opening file");
	return 2;
	}
	AVL* rootAVL = NULL;
		switch(argc){     //switch based on the number of arguments (if argc == 3, print avl (default case)) , if argc == 4 print in reverse OR based on the sort argument, if argc == 5 , print in reverse AND based on the sort argument
		case 3:
				while(fgets(line, 255, file)){
					rootAVL = insertAVL(rootAVL, line, &h);

				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
				return 3;
				}

				printAVL(rootAVL,file);
				fclose(file);
		break;

		case 4:
			if (!strcmp(argv[3], "--tab")){
				Chain* rootChain = NULL;
				while(fgets(line, 255, file)!=NULL){
					rootChain=insertChain(rootChain,line);
				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
					return 3;
				}
				printChain(rootChain,file);
				fclose(file);
			}
				
			else if (!strcmp(argv[3], "--abr")){
				ABR* rootABR = NULL;
				while(fgets(line, 255, file)){
					rootABR = insertABR(rootABR, line);
				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
					return 3;
				}
				printABR(rootABR,file);
				fclose(file);
			}
				
			else if (!strcmp(argv[3], "--avl")){
				AVL* rootAVL = NULL;
				while(fgets(line, 255, file)){
					rootAVL = insertAVL(rootAVL, line, &h);

				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
				return 3;
				}
				printAVL(rootAVL,file);
				fclose(file);
			}
				
			else if (!strcmp(argv[3], "-r")){
				AVL* rootAVL = NULL;
				while(fgets(line, 255, file)){
					rootAVL = insertAVL(rootAVL, line, &h);

				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
				return 3;
				}

				printAVL_reverse(rootAVL,file);
				fclose(file);
			}
			break;

		case 5:

			if (!strcmp(argv[3], "--tab") || !strcmp(argv[4], "--tab")){
				Chain* rootChain = NULL;
				while(fgets(line, 255, file)!=NULL){
					rootChain=insertChain_reverse(rootChain,line);
				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
				return 3;
				}
				printChain(rootChain,file);
				fclose(file);
			}
				
			else if (!strcmp(argv[3], "--abr") || !strcmp(argv[4], "--abr")){
				ABR* rootABR = NULL;
				while(fgets(line, 255, file)){
					rootABR = insertABR(rootABR, line);
				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
				return 3;
				}
				printABR_reverse(rootABR,file);
				fclose(file);
			}
				
			else if (!strcmp(argv[3], "--avl") || !strcmp(argv[4], "--avl")){
				AVL* rootAVL = NULL;
				while(fgets(line, 255, file)){
					rootAVL = insertAVL(rootAVL, line, &h);

				}
				fclose(file);

				file=fopen(argv[2],"w");
				if (file == NULL) {
					printf("error opening file");
				return 3;
				}
				printAVL_reverse(rootAVL,file);
				fclose(file);
			}
		break;
	}

	return 0;
}



