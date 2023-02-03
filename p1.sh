
#!/bin/bash

	gnuplot -p <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Station"
		set ylabel "Pressure"
		plot "pressure.csv" u 1:3:4 w filledcurve fc rgb #80E0A080 title "Pressure max and min", "pressure.csv" u 1:2 w smooth mcspline lw 2 title "Average Pressure"
EOF
