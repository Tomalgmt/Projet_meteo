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
Fp_bool=0
Gp_bool=0
Sp_bool=0
Ap_bool=0
Op_bool=0
Qp_bool=0

#Graph Parameters
tp_bool=0
hp_bool=0
pp_bool=0
wp_bool=0
mp_bool=0
dp_bool=0

#Sort Parameters
Cp_bool=0
Vp_bool=0
Bp_bool=0

#Functional variable
date_part1=""
date_part2=""
currdatemax_1=0
currdatemax_2=0
currdatemax_3=0
currdatemin_1=0
currdatemin_2=0
currdatemin_3=0
day_min=5
day_max=31
month_min=2
month_max=12
year_min=5
year_max=2000


#}------------------------------------------[SCRIPT]-------------------------------------------------{
while getopts "thpwmd:CVBy" date; do
    case "${date}" in
        y)
		show_help
		exit 0
		;;
        t) 
		echo "-t"
		tp_bool=1
		;;
#Ajouter les differentes options des paramètres
        h) 
		echo "-h"
		hp_bool=1
		;;
        p) 
		echo "-p"
		pp_bool=1
		;;
        w) 
		echo "-w"
		wp_bool=1
		;;
        m) 
		echo "-m"
		tp_bool=1
		;;
        C) 
		echo "--trichain"
		tT_bool=1
		;;
        V) 
		echo "--triavl"
		tV_bool=1
		;;
        B) 
		echo "--triabr"
		tB_bool=1
		;;
	d)
		echo "-d"
		choosen_date=${OPTARG}
		echo "${choosen_date}"
		td_bool=1
		;;
        B) 
		echo "--triabr"
		tB_bool=1
		;;
        F) 
		echo "-France"
		tF_bool=1
		;;
        G) 
		echo "-Guyane"
		tG_bool=1
		;;
        S) 
		echo "-Stp&mql"
		tS_bool=1
		;;
        A) 
		echo "-Antilles"
		tA_bool=1
		;;
        O) 
		echo "-OceanIndien"
		tO_bool=1
		;;
        Q) 
		echo "-Antartique"
		tQ_bool=1
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


if [ td_bool ]
then
	date_part1=$(echo $choosen_date | cut -d_ -f1)
# echo "${date_part1}" FONCTIONNE
	date_part2=$(echo $choosen_date | cut -d_ -f2) 
# echo "${date_part2}" FONCTIONNE
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


echo "${currdatemin_1}"
echo "${currdatemin_2}"
echo "${currdatemin_3}"
echo "${currdatemax_1}"
echo "${currdatemax_2}"
echo "${currdatemax_3}"



if [ ${hp_bool} -eq 1 ]
then
	touch altitude.txt << [ sed 1d meteo_filtered_data.csv | cut -d';' -f14 ]
fi







