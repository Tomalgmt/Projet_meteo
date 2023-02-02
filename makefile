
sort: main.c avl_sort.o chain_sort.o abr_sort.o
	gcc main.c -o sort

avl_sort.o: header.h avl_sort.c
	gcc -c avl_sort.c

abr_sort.o: abr_sort.c header.h
	gcc -c abr_sort.c

chain_sort.o: chain_sort.c header.h
	gcc -c chain_sort.c

clean:
	rm *.o sort
