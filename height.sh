#!/bin/bash

	gnuplot -p <<- EOF
		reset session
		set contour base
		set border 4095 front lt black lw 1 dashtype solid
		unset key
		set samples 50,50
		set isosamples 50,50
		set xyplane relative 0
		set dgrid3d
		set pm3d
		unset surface
		set view map
		set xlabel "Latitude"
		set ylabel "Longitude"
		set cblabel "Height"
		set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front noinvert bdefault
		splot "blank.dat" w pm3d
EOF
