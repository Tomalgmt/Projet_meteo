#!/bin/bash

	gnuplot -p <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Date"
		set ylabel "Temperature"
		plot "temperature.csv" u 1:2 w line lw 3 lc rgb "navy" title "Average temperature"
EOF
