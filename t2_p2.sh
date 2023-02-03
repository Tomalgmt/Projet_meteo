#!/bin/bash

	gnuplot -p <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Station"
		set ylabel "Temperature"
		plot "temperature.csv" u 1:2 w smooth mcspline lw 2
EOF
