
tri: main.c avltest2.o tritab.o triabr.o
	gcc main.c -o tri

avltest2.o: header.h avltest2.c
	gcc -c avltest2.c

triabr.o: triabr.c header.h
	gcc -c triabr.c

tritab.o: tritab.c header.h
	gcc -c tritab.c

clean:
	rm *.o tri
