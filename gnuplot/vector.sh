#!/bin/bash

    gnuplot -p <<- EOF
	set datafile separator ";"
        set xlabel "a"
        set ylabel "b"
	set samples 100
        set title "Graph of local temperatures" 
        plot "vector.csv" u 3:4:1:2 w vectors
EOF
