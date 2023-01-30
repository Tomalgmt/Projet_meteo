#!/bin/bash

# Usage Info:

show_help() {
cat << EOF
Usage:
Script --help,-h,-t,-a,-p,-m,-v,-w,--trichaine,--triavl,--triabr,-d [Day-Month-Year]_[Day-Month-Year]

List of the arguments : 

	--help					Display this menu
	-t[1-3]					Display a graph of the temperature in the choosen date and the choosen location (
	-h					Display a graph of the altitude in the choosen date and the choosen location
	-p[1-3]					Display a graph of the pressure in the choosen date and the choosen location
	-w					Display a graph of the wind in the choosen date and the choosen location
	-m					Display a graph of the humidity in the choosen date and the choosen location
	--trichain				Sort the data file with a chain sort
	--triavl				Sort the data file with an avl sort
	--triabr 				sort the data file with an abr sort
	-d [Day-Month-Year]_[Day-Month-Year]	Choose a date between [date1] and [date2] to display the graphs


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
    '--trichain') set -- "$@" '-C'   ;;
    '--triavl')   set -- "$@" '-V'   ;;
    '--triabr')     set -- "$@" '-B'   ;;
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
while getopts "t:hp:wmd:CVBy" date; do
    case "${date}" in
        y)
		show_help
		exit 0
		;;
        t) 
		echo "-t"
		if [ ${OPTARG} -eq 1 -o ${OPTARG} -eq 2 -o ${OPTARG} -eq 3 ]
		then
			tt_bool=${OPTARG}
		else
			echo "-t ARGUMENT ERROR"
			exit 0
		fi
		echo "$tt_bool"
		;;
#Ajouter les differentes options des paramètres
        h) 
		echo "-h"
		ht_bool=1
		;;
        p) 
		echo "-p"
		if [ ${OPTARG} -eq 1 -o ${OPTARG} -eq 2 -o ${OPTARG} -eq 3 ]
		then
			pt_bool=${OPTARG}
		else
			echo "-p ARGUMENT ERROR"
			exit 0
		fi
		echo "$pt_bool"
		;;
        w) 
		echo "-w"
		wt_bool=1
		;;
        m) 
		echo "-m"
		mt_bool=1
		;;
        C) 
		echo "--trichain"
		Tt_bool=1
		;;
        V) 
		echo "--triavl"
		Vt_bool=1
		;;
        B) 
		echo "--triabr"
		Bt_bool=1
		;;
	d)
		echo "-d"
		choosen_date=${OPTARG}
		echo "${choosen_date}"
		dt_bool=1
		;;
        B) 
		echo "--triabr"
		Bt_bool=1
		;;
        F) 
		echo "-France"
		Ft_bool=1
		;;
        G) 
		echo "-Guyane"
		Gt_bool=1
		;;
        S) 
		echo "-Stp&mql"
		St_bool=1
		;;
        A) 
		echo "-Antilles"
		At_bool=1
		;;
        O) 
		echo "-OceanIndien"
		Ot_bool=1
		;;
        Q) 
		echo "-Antartique"
		Qt_bool=1
		;;
	*)
		exit 0
		;;
    esac
done

#}--------------------------------------[VERIFICATIONS]----------------------------------------------{

if [ $# == 0 ]
then
	echo "PARAMETER ERROR"
	exit 0
fi

echo "test"


if [ ${td_bool} ]
then
	date_part1=$(echo $choosen_date | cut -d_ -f1)
	date_part2=$(echo $choosen_date | cut -d_ -f2) 
	if [ $(echo $date_part1 | cut -d'-' -f1) -lt $day_min ]
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
	if [ $(echo $date_part1 | cut -d'-' -f3) -lt $year_min ]
	then
		echo "DATE ERROR MIN YEAR"
	else
		currdatemin_3=$(echo $date_part1 | cut -d'-' -f3)
	fi
	if [ $(echo $date_part2 | cut -d'-' -f1) -gt $day_max ]
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
	if [ $(echo $date_part2 | cut -d'-' -f3) -gt $year_max ]
	then
		echo "DATE ERROR MAX YEAR"
	else
		currdatemax_3=$(echo $date_part2 | cut -d'-' -f3)
	fi
	if [ ${currdatemax_3} -lt ${currdatemin_3} ]
	then	
		echo "ERROR DATE FORMAT"
		exit 0
	else	
		if [ ${currdatemax_3} -eq ${currdatemin_3} ]
		then
			if [ ${currdatemax_2} -lt ${currdatemin_2} ]
			then
				echo "ERROR DATE FORMAT"
				exit 0
			else
				if [ ${currdatemax_2} -eq ${currdatemin_2} ]
				then
					if [ ${currdatemax_1} -lt ${currdatemin_1} ]
					then
						echo "ERROR DATE FORMAT"
						exit 0
					fi
					if [ ${currdatemax_1} -eq ${currdatemin_1} ]
					then
						echo "ERROR EQUALE DATE"
						exit 0
					fi
				fi
			fi
		fi
	fi
				
fi

#Finir les Verifications DE DATE et faire les nouvelles


#PRIORITEE ORDRE :   EN PREMIER LE --HELP    EN DEUXIEME LA DATE	EN TROISIEME 

#COMMENCER L'EXECUTION DU SCRIPT QUI FAIT LES CUT EN FOCNTION DES PARAMETRES DANS UN NOUVEAU CSV


#DATE FONCTIONNE


if [ ${tt_bool} -eq 1 ]		#TRI DES STATIONS
then
	touch stationid.txt
	touch temp.txt #11
	cut -d';' -f1 meteo_filtered_data.csv | sed 1d | >>stationid.txt
	cut -d';' -f11,12,23 meteo_filtered_data.csv | sed 1d | >>temp.txt
	rm stationid.txt
	rm temp.txt
fi
if [ ${tt_bool} -eq 2 ]		#TRI DES COORDONNEES
then
	touch coord.txt
	touch temp.txt #11
	cut -d';' -f1 meteo_filtered_data.csv | sed 1d | >>coord.txt
	cut -d';' -f11,12,23 meteo_filtered_data.csv | sed 1d | >>temp.txt
	rm stationid.txt
	rm temp.txt
fi
if [ ${tt_bool} -eq 3 ]		#TRI DATE PUIS STATION
then
	echo "coucou"
fi

if [ ${pt_bool} -eq 1 ]
then
	echo "coucou2"
fi
if [ ${pt_bool} -eq 2 ]
then
	echo "coucou2"
fi
if [ ${pt_bool} -eq 3 ]
then
	echo "coucou2"
fi
if [ ${ht_bool} -eq 1 ]
then
	touch altitude.txt 
	cut -d';' -f14 meteo_filtered_data.csv | sed 1d | >>altitude.txt
fi
if [ ${wt_bool} -eq 1 ]
then
	touch winddir.txt 
	touch windsp.txt 
	cut -d';' -f4 meteo_filtered_data.csv | sed 1d | >>winddir.txt
	cut -d';' -f5 meteo_filtered_data.csv | sed 1d | >>windsp.txt
fi
if [ ${mt_bool} -eq 1 ]
then
	touch humidity.txt 
	cut -d';' -f6 meteo_filtered_data.csv | sed 1d | >>humidity.txt
fi





