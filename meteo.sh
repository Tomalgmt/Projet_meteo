#!/bin/bash

# Usage Info:

show_help() {
cat << EOF
Usage:
Script --help,-h,-t,-a,-p,-m,-v,-w,--trichaine,--triavl,--triabr,-d [Day-Month-Year]_[Day-Month-Year]
List of the arguments : 
	--help					Display this menu
	-t1					Display a graph of the average temperature with the maximum and minimum temperature as error margins based on the choosen location
	-t2					Display a graph of the average temperature based on the choosen date
	-t3					Display a graph of the temperature based on the choosen date and the choosen location
	-h					Display a graph of the altitude in the choosen date and the choosen location
	-p1					Display a graph of the average pressure with the maximum and minimum pressure as error margins based on the choosen location
	-p2					Display a graph of the average pressure based on the choosen date
	-p3					Display a graph of the pressure based on the choosen date and the choosen location
	-w					Display a graph of the wind in the choosen date and the choosen location
	-m					Display a graph of the humidity in the choosen date and the choosen location
	--trichain				Sort the data file with a chain sort
	--triavl				Sort the data file with an avl sort
	--triabr 				sort the data file with an abr sort
	-d [Year-Month-Day]_[Year-Month-Day]	Choose a date between [date1] and [date2] to display the graphs
#a continuer avec les stations
Error that may occur:
Attention to write correctly the date.
The date have to be in a range of 1 Day beetween [Date1] and [Date2]
The date parameter is in this format (example) : -d 31-06-2003_01-07-2003
EOF
}




<<'COMMENTS'
 	
COMMENTS

for arg in "$@"; do
  shift
  case "$arg" in
    '--help')   set -- "$@" '-y'   ;;
    '--tab') set -- "$@" '-C'   ;;
    '--avl')   set -- "$@" '-V'   ;;
    '--abr')     set -- "$@" '-B'   ;;
    *)          set -- "$@" "$arg" ;;
  esac
done

OPTIND=1;





#FORME DU FICHIER CSV :
# Station;date;pression mer;direction du vent; vitesse du vent; humiditée; pression station; variation pression; precipitation; coordonnées ; temperature; temp min ; temp max ; altitude; commune

#}---------------------------------[VARIABLES]-------------------------------------------------------{

#Location
Ft_bool=0
Gt_bool=0
St_bool=0
At_bool=0
Ot_bool=0
Qt_bool=0
Region_bool=0

#Graph Parameters
tt_bool=0
ht_bool=0
pt_bool=0
wt_bool=0
mt_bool=0
dt_bool=0

#Sort Parameters
Ct_bool=0
Vt_bool=0
Bt_bool=0
sort_bool=0


#Functional variable
date_part1=""
date_part2=""
currdatemax_1=0
currdatemax_2=0
currdatemax_3=0
currdatemin_1=0
currdatemin_2=0
currdatemin_3=0
day_min=0
day_max=31
month_min=0
month_max=12
year_min=0
year_max=2100


#}------------------------------------------[SCRIPT]-------------------------------------------------{
while getopts "t:hp:wmd:CVByFGSAOQ" date; do
    case "${date}" in
        y)
		show_help
		exit 0
		;;
        t) 
		if [ ${OPTARG} -eq 1 -o ${OPTARG} -eq 2 -o ${OPTARG} -eq 3 ]
		then
			tt_bool=${OPTARG}
		else
			echo "-t ARGUMENT ERROR"
			exit 0
		fi
		;;
        h) 
		ht_bool=1
		;;
        p) 
		if [ ${OPTARG} -eq 1 -o ${OPTARG} -eq 2 -o ${OPTARG} -eq 3 ]
		then
			pt_bool=${OPTARG}
		else
			echo "-p ARGUMENT ERROR"
			exit 0
		fi
		;;
        w) 
		wt_bool=1
		;;
        m) 
		mt_bool=1
		;;
        C) 
		Tt_bool=1
		;;
        V) 
		Vt_bool=1
		;;
        B) 
		Bt_bool=1
		;;
	d)
		choosen_date=${OPTARG}
		dt_bool=1
		;;
        F) 
		Ft_bool=1
		;;
        G) 
		Gt_bool=1
		;;
        S) 
		St_bool=1
		;;
        A) 
		At_bool=1
		;;
        O) 
		Ot_bool=1
		;;
        Q) 
		Qt_bool=1
		;;
	*)
		echo "ERROR ARGUMENT INVALID type --help for more"
		exit 0
		;;
    esac
done


Region_bool="$((Ft_bool+Gt_bool+St_bool+At_bool+Ot_bool+Qt_bool))"
#}--------------------------------------[VERIFICATIONS]----------------------------------------------{

if [ $# == 0 ]
then
	echo "PARAMETER ERROR"
	exit 0
fi

sort_bool_verif="$((Ct_bool+Vt_bool+Bt_bool))"
if [ ${sort_bool} -gt 1 ]
then
	echo "PARAMETER ERROR : ONLY 1 SORT PARAMETER ALLOWED"
	exit 0
fi



if [ ${dt_bool} -eq 1 ]
then
	date_part1=$(echo $choosen_date | cut -d'_' -f1)
	date_part2=$(echo $choosen_date | cut -d'_' -f2)
	if [ $(echo $date_part1 | cut -d'-' -f1) -lt $year_min ]
	then
		echo "DATE ERROR MIN DAY"
		echo $(echo $date_part1 | cut -d'-' -f1)
		exit 0
	else 
		currdatemin_1=$(echo $date_part1 | cut -d'-' -f1)
	
	fi
	if [ $(echo $date_part1 | cut -d'-' -f2) -lt $month_min ]
	then
		echo "DATE ERROR MIN MONTH"
	else
		currdatemin_2=$(echo $date_part1 | cut -d'-' -f2)
	fi
	if [ $(echo $date_part1 | cut -d'-' -f3) -lt $day_min ]
	then
		echo "DATE ERROR MIN YEAR"
	else
		currdatemin_3=$(echo $date_part1 | cut -d'-' -f3)
	fi
	if [ $(echo $date_part2 | cut -d'-' -f1) -gt $year_max ]
	then
		echo "DATE ERROR MAX DAY"
	else 
		currdatemax_1=$(echo $date_part2 | cut -d'-' -f1)
	fi
	if [ $(echo $date_part2 | cut -d'-' -f2) -gt $month_max ]
	then
		echo "DATE ERROR MAX MONTH"
	else
		currdatemax_2=$(echo $date_part2 | cut -d'-' -f2)
	fi
	if [ $(echo $date_part2 | cut -d'-' -f3) -gt $day_max ]
	then
		echo "DATE ERROR MAX YEAR"
	else
		currdatemax_3=$(echo $date_part2 | cut -d'-' -f3)
	fi
	if [ ${currdatemax_1} -lt ${currdatemin_1} ]
	then	
		echo "ERROR DATE FORMAT"
		exit 0
	else	
		if [ ${currdatemax_1} -eq ${currdatemin_1} ]
		then
			if [ ${currdatemax_2} -lt ${currdatemin_2} ]
			then
				echo "ERROR DATE FORMAT"
				exit 0
			else
				if [ ${currdatemax_2} -eq ${currdatemin_2} ]
				then
					if [ ${currdatemax_3} -lt ${currdatemin_3} ]
					then
						echo "ERROR DATE FORMAT"
						exit 0
					fi
					if [ ${currdatemax_3} -eq ${currdatemin_3} ]
					then
						echo "ERROR EQUALE DATE"
						exit 0
					fi
				fi
			fi
		fi
	fi
				
fi



#}---------------------------------------------[FUNCTIONAL]---------------------------------------------{





#}---------------------------------------------[DATE FILTER]---------------------------------------------{

if [ ${dt_bool} -eq 1 ]
then
	cat meteo_filtered_data_v1.csv | awk -F'[;T+:-]' -v currdatemin_1="$currdatemin_1" -v currdatemin_2="$currdatemin_2" -v currdatemin_3="$currdatemin_3" -v currdatemax_1="$currdatemax_1" -v currdatemax_2="$currdatemax_2" -v currdatemax_3="$currdatemax_3" '{
	if( $2 > currdatemin_1 && $2 < currdatemax_1 ){
		print $0
	} 
	else{
		if( $2==currdatemin_1 ){
			if( $3 > currdatemin_2 ){
				print $0
			}
			else{
				if( $3 >= currdatemin_2 ){
					if( $4>=currdatemin_3 ){
						print $0
					}
				}
			}
		}
		else{
			if( $2 == currdatemax_1 ){
				if( $3 < currdatemax_2 ){
					print $0
				}
				else{
					if( $3 <= currdatemax_2 ){
						if ( $4 <= currdatemax_3 ){
							print $0
						}
					}
				}
			}
		}				 
	}
	}' >date_filtered.csv

	
	
	
#}----------------------------------------------------------------[REGION FILTER]------------------------------------------------------------------{

#}---------------------------------------------[FRANCE]-----------------------------------------------{

	if [ ${Ft_bool} -eq 1 ]
	then	
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 0 && $15 <= 95999 {print $0}' date_filtered.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[GUYANE]---------------------------------------------{

	if [ ${Gt_bool} -eq 1 ]
	then	
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97300 && $15 <= 97399 {print $0}' date_filtered.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[ST-PIERRE & MIQUELON]---------------------------------------------{
	
	if [ ${St_bool} -eq 1 ]
	then	
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97500 && $15 <= 97599 {print $0}' date_filtered.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[ANTILLES]---------------------------------------------{
	
	if [ ${At_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97100 && $15 <= 97299 {print $0}' date_filtered.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[INDIEN OCEAN]---------------------------------------------{
	
	if [ ${Ot_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97600 && $15 <= 97699 {print $0}' date_filtered.csv > region_filtered.csv
		awk -F";" '$15 >= 97400 && $15 <= 97499 {print $0}' date_filtered.csv >> region_filtered.csv
	fi
	
#}---------------------------------------------[ANTARCTIQ OCEAN]---------------------------------------------{
	
	if [ ${Qt_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 98400 && $15 <= 98499 {print $0}' date_filtered.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[GENERATION OF THE FIRST GRAPHS]---------------------------------------------{
	
	start_file="date_filtered.csv"
	if [ "${Region_bool}" -eq 1 ]
	then			#Check the region filter
		start_file="region_filtered.csv"
	fi
	if [ ${tt_bool} -eq 1 ]	
	then
	
		cut -d';' -f1,11 $start_file > dRtemp1_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		filename=dRtemp1_cut.csv
		col1=($(cut -d';' -f1 $filename | sort | uniq))
		for val in "${col1[@]}";do
			avg=$(grep -w $val $filename | cut -d';' -f2 | awk '{sum+=$1} END {print sum/NR}')
			min=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 { min=$1 } $1 <= min { min=$1 } END { print min }')
			max=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 { max=$1 } $1 > max { max=$1 } END { print max }')
			echo "$val;$avg;$min;$max" >> dRtemp1_final.csv
			#do the average temperature of each station
		done
		if [ $start_file != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file 2> /dev/null
		fi
		echo "Creation du graphe"
		rm dRtemp1_cut.csv
		gnuplot -p 2> /dev/null <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Station"
		set ylabel "Temperature"
		plot "dRtemp_final.csv" u 1:4:3 w filledcurve title "Temperature", "dRtemp1_final.csv" u 1:2 w line lw 2
		EOF
		rm dRtemp1_final.csv
	fi
	if [ ${tt_bool} -eq 2 ]		#TRI DES COORDONNEES
	then
		cut -d';' -f2,11 $start_file > dRtemp2_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ $start_file != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRtemp2_cut.csv" "dRtemp2_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRtemp2_cut.csv" "dRtemp2_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRtemp2_cut.csv" "dRtemp2_cut.csv" --tab
		fi
			
	fi
	if [ ${tt_bool} -eq 3 ]		#TRI DATE PUIS STATION
	then
		cut -d';' -f1,2,11 $start_file > dRtemp3_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRtemp3_cut.csv" "dRtemp3_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRtemp3_cut.csv" "dRtemp3_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRtemp3_cut.csv" "dRtemp3_cut.csv" --tab
		fi
	fi	
	if [ ${pt_bool} -eq 1 ]
	then
		cut -d';' -f1,7 $start_file > dRpress1_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		filename=dRpress1_cut.csv
		
		col1=($(cut -d';' -f1 $filename | sort | uniq ))
		for val in "${col1[@]}";do
			avg=$(grep -w $val $filename | cut -d';' -f2 | awk '{sum+=$1} END {print sum/NR}')
			min=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 { min=$1 } $1 < min { min=$1 } END { print min }')
			max=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 { max=$1 } $1 > max { max=$1 } END { print max }')
			echo "$val;$avg;$min;$max" >> dRpress1_final.csv  
			#do the average pressure of each station
		done
		echo "Creation du graphe"
		rm dRpress1_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm "$start_file"
		fi
		gnuplot -p 2> /dev/null <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Station"
		set ylabel "Pressure"
		plot "dRpress1_final.csv" u 1:4:3 w filledcurve title "Pressure", "dRpress1_final.csv" u 1:2 w line lw 2
		EOF
		rm dRpress1_final.csv
	fi
	if [ ${pt_bool} -eq 2 ]
	then
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		cut -d';' -f2,7 $start_file > dRpress2_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRpress2_cut.csv" "dRpress2_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRpress2_cut.csv" "dRpress2_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRpress2_cut.csv" "dRpress2_cut.csv" --tab
		fi
	fi
	if [ ${pt_bool} -eq 3 ]
	then
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		cut -d';' -f1,2,7 $start_file > dRpress3_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRpress3_cut.csv" "dRpress3_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRpress3_cut.csv" "dRpress3_cut.csv" --abr
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRpress3_cut.csv" "dRpress3_cut.csv" --tab
		fi
	fi
	if [ ${ht_bool} -eq 1 ]
	then
		cut -d';' -f10,14 $start_file > dRheight_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRheight_cut.csv" "dRheight_cut.csv" --avl -
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRheight_cut.csv" "dRheight_cut.csv" --abr -r
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRheight_cut.csv" "dRheight_cut.csv" --tab -r
		fi
	fi
	if [ ${wt_bool} -eq 1 ]
	then
		cut -d';' -f4,5,10 $start_file > dRwind_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRwind1_cut.csv" "dRwind_cut.csv" --avl -r
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRwind1_cut.csv" "dRwind1_cut.csv" --abr -r
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRwind1_cut.csv" "dRwind1_cut.csv" --tab -r
		fi
	fi
	if [ ${mt_bool} -eq 1 ]
	then
		cut -d';' -f10,6 $start_file > dRmoist_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "dRmoist_cut.csv" "dRmoist_cut.csv" --avl -r
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "dRmoist_cut.csv" "dRmoist_cut.csv" --abr -r
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "dRmoist_cut.csv" "dRmoist_cut.csv" --tab -r
		fi
	fi	
	rm date_filtered.csv
fi
	


#}------------------------------------------------------------------[NO DATE FILTER]------------------------------------------------------------------------{

if [ ${dt_bool} -eq 0 ]
then
#}---------------------------------------------------------[REGION FILTER]------------------------------------------------{

#}---------------------------------------------[FRANCE]---------------------------------------------{

	if [ ${Ft_bool} -eq 1 ]
	then	
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 0 && $15 <= 95999 {print $0}' meteo_filtered_data_v1.csv > region_filtered.csv
	fi

#}---------------------------------------------[GUYANE]---------------------------------------------
	if [ ${Gt_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97300 && $15 <= 97399 {print $0}' meteo_filtered_data_v1.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[ST-PIERRE & MIQUELON]---------------------------------------------{
	
	if [ ${St_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97500 && $15 <= 97599 {print $0}' meteo_filtered_data_v1.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[ANTILLES]---------------------------------------------{
	
	if [ ${At_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97100 && $15 <= 97299 {print $0}' meteo_filtered_data_v1.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[INDIAN OCEAN]---------------------------------------------{
	
	if [ ${Ot_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 97600 && $15 <= 97699 {print $0}' meteo_filtered_data_v1.csv > region_filtered.csv
		awk -F";" '$15 >= 97400 && $15 <= 97499 {print $0}' meteo_filtered_data_v1.csv >> region_filtered.csv	
	fi
	
#}---------------------------------------------[ANTARTIQUE OCEAN]---------------------------------------------{
	
	if [ ${Qt_bool} -eq 1 ]
	then
		echo "Generation dossier csv par date et par region"
		awk -F";" '$15 >= 98400 && $15 <= 98499 {print $0}' meteo_filtered_data_v1.csv > region_filtered.csv
	fi
	
#}---------------------------------------------[GENERATION OF THE FIRST GRAPHS]---------------------------------------------{
	
	start_file="meteo_filtered_data_v1.csv"
	if [ "${Region_bool}" -eq 1 ]
	then			#Check the region filter
		start_file="region_filtered.csv"
	fi
	
	if [ ${tt_bool} -eq 1 ]
	then
		cut -d';' -f1,11 $start_file > dRtemp1_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		filename=dRtemp1_cut.csv
		col1=($(cut -d';' -f1 $filename | sort | uniq))
		for val in "${col1[@]}";do
			avg=$(grep -w $val $filename | cut -d';' -f2 | awk '{sum+=$1} END {print sum/NR}')
			min=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 { min=$1 } $1 <= min { min=$1 } END { print min }')
			max=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 { max=$1 } $1 > max { max=$1 } END { print max }')
			echo "$val;$avg;$min;$max" >> dRtemp1_final.csv
		#do the average temperature of each station
		done
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		echo "Creation du graphe"
		gnuplot -p 2> /dev/null <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Station"
		set ylabel "Temperature"
		plot "dRtemp_final.csv" u 1:4:3 w filledcurve title "Temperature", "dRtemp1_final.csv" u 1:2 w line lw 2
		EOF
		rm dRtemp1_cut.csv
		rm dRtemp1_final.csv
	fi

	if [ ${tt_bool} -eq 2 ]		
	then
		cut -d';' -f1,11 $start_file > temp2_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "temp2_cut.csv" "temp2_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "temp2_cut.csv" "temp2_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "temp2_cut.csv" "temp2_cut.csv" --tab
		fi
	fi
	if [ ${tt_bool} -eq 3 ]		
	then
		cut -d';' -f1,2,11 $start_file > temp3_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "temp3_cut.csv" "temp3_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "temp3_cut.csv" "temp3_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "temp3_cut.csv" "temp3_cut.csv" --tab
		fi
		exit 0				
	fi	
	if [ ${pt_bool} -eq 1 ]
	then
		cut -d';' -f1,7 $start_file > dRpress1_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		filename=dRpress1_cut.csv
		
		col1=($(cut -d';' -f1 $filename | sort -u))
		for val in "${col1[@]}"; do
		  avg=$(grep -w $val $filename | cut -d';' -f2 | awk '{sum+=$1} END {printf "%.2f", sum/NR}')
		  min=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 {min=$1} $1 <= min {min=$1} END {printf "%.2f", min}')
		  max=$(grep -w $val $filename | cut -d';' -f2 | awk 'NR == 1 {max=$1} $1 > max {max=$1} END {printf "%.2f", max}')
		  echo "$val;$avg;$min;$max" >> dRpress1_final.csv
		done 
			#do the average pressure of each station
		echo "Creation du graphe"
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		rm dRpress1_cut.csv
		gnuplot -p 2> /dev/null <<- EOF
		set grid nopolar
		set style data lines
		set datafile separator ";"
		set ytics norangelimit logscale autofreq
		set xlabel "Station"
		set ylabel "Pressure"
		plot "dRpress1_final.csv" u 1:4:3 w filledcurve title "Pressure", "dRpress1_final.csv" u 1:2 w line lw 2
		EOF
		rm dRpress1_final.csv
	fi
	if [ ${pt_bool} -eq 2 ]
	then
		cut -d';' -f2,7 $start_file > press2_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "press2_cut.csv" "press2_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "press2_cut.csv" "press2_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "press_cut3.csv" "press2_cut.csv" --tab
		fi
	fi
	if [ ${pt_bool} -eq 3 ]
	then
		cut -d';' -f1,2,7 $start_file > dRpress1_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "press3_cut.csv" "press3_cut.csv" --avl
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "press3_cut.csv" "press3_cut.csv" --abr
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "press3_cut.csv" "press3_cut.csv" --tab
		fi
	fi
	if [ ${ht_bool} -eq 1 ]
	then
		cut -d';' -f10,14 $start_file > height_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "height_cut.csv" "height_cut.csv" --avl -r
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "height_cut.csv" "height_cut.csv" --abr -r
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "height_cut.csv" "height_cut.csv" --tab -r
		fi
	fi			
	if [ ${wt_bool} -eq 1 ]
	then
		cut -d';' -f4,5,10 $start_file > wind_cut.csv
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "wind_cut.csv" "wind_cut.csv" --avl -r
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "wind_cut.csv" "wind_cut.csv" --abr -r
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "wind_cut.csv" "wind_cut.csv" --tab -r
		fi
	fi
	if [ ${mt_bool} -eq 1 ]
	then
		cut -d';' -f10,6 $start_file > moist_cut.csv
		echo "Separation des colonnes pour la creation des graphes"
		if [ "$start_file" != "meteo_filtered_data_v1.csv" ]
		then
			rm $start_file
		fi
		if [ $sort_bool_verif -eq 0 -o $Vt_bool -eq 1 ]
		then
			./sort "moist_cut.csv" "moist_cut.csv" --avl -r
		fi
		if [ $Bt_bool -eq 1 ]
		then
			./sort "moist_cut.csv" "moist_cut.csv" --abr -r
		fi
		if [ $Ct_bool -eq 1 ]
		then
			./sort "moist_cut.csv" "moist_cut.csv" --tab -r
		fi			
	fi
fi


