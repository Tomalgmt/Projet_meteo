#!/bin/bash

	gnuplot -p <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xrange [50:150]
		set xlabel "Station"
		set ylabel "Temperature"
		plot "temperature.csv" u 1:3:4 w filledcurve title "Temperature"
EOF
