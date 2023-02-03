# PROJECT METEO GRAPHIC


## SUMMARY
1. [GENERAL INFORMATIONS](#informations-générales)
2. [UTILISATION](#utilisation)
3. [CREATORS](#créateurs)

## INFORMATIONS GÉNÉRALES


This code is a compilation of differents scripts that will take data from a databank file and will display differents graphics according to the options choosen. It uses two different programmation languages, first bash for taking the arguments and cutting the data then il will use the C language to sort the filtered data and it will reuse the bash in addition with the gnuplot library to print a graph.


## UTILISATION

To compile the sort algorithms, put all of the files of the github in the same directory then use the command :

```c
  $ make
```
To use the programm :

```bash
  $ bash meteo.sh --help
```
### Decouvrir l'outil

To discover the tool, use tjis command in the linux terminal : 

```bash
  $ bash meteo.sh --help
```

### WARNINGS 

This code is not entirely safe, be warned that using other options different that used in the script may potentially causes some problems and will not display the graphs properly. It could also slow down your computer.



## CRÉATEURS

Nathan Kem (aka Soraxy) and Tom Allaguillemette (aka Moutsss) MI6 Preing 2
