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


if [ ${dt_bool} ]
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


#Finir les Verifications DE DATE et faire les nouvelles


#PRIORITEE ORDRE :   EN PREMIER LE --HELP    EN DEUXIEME LA DATE	EN TROISIEME 

#COMMENCER L'EXECUTION DU SCRIPT QUI FAIT LES CUT EN FOCNTION DES PARAMETRES DANS UN NOUVEAU CSV


#DATE FONCTIONNE

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
	
	
	
	if [ ${Ft_bool} -eq 1 ]
	then	
		echo date_filtered.csv | awk -f'[;]' '{
			if( $15 > 0 && $15 <= 95999 ){
				print $0
			}
		}' > region_filtered.csv
		#CUT LES date_filtered EN REGION AVEC CODE COMMUNE (tri)
		if [ ${tt_bool} -eq 1 ]		#TRI DES STATIONS
		then
			cut -d';' -f1,11,12,13 region_filtered.csv | sed 1d >temp.txt	
			rm temp.txt
			rm stationid.txt
		fi
		if [ ${tt_bool} -eq 2 ]		#TRI DES COORDONNEES
		then
			cut -d';' -f1 date_filtered.csv | sed 1d >coord.txt
			cut -d';' -f11,12,13 meteo_filtered_data_v1.csv | sed 1d >temp.txt
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
		f	i
		if [ ${pt_bool} -eq 3 ]
		then
			echo "coucou2"
		fi
		if [ ${ht_bool} -eq 1 ]
		then
			touch altitude.txt 
			cut -d';' -f14 meteo_filtered_data_v1.csv | sed 1d | >>altitude.txt
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
fi
	if [ ${Gt_bool} -eq 1 ]
	then	
		echo date_filtered.csv | awk -f'[;]' '{
			if( $15 >= 97300 && $15 <= 97399 ){
				print $0
			}
		}' > region_filtered.csv
	fi
	
	
	
	if [ ${St_bool} -eq 1 ]
	then	
		echo date_filtered.csv | awk -f'[;]' '{
			if( $15 >= 97500 && $15 <= 97599 ){
				print $0
			}
		}' > region_filtered.csv
	fi
	
	
	
	if [ ${At_bool} -eq 1 ]
	then
		echo date_filtered.csv | awk -f'[;]' '{
			if( $15 >= 97100 && $15 <= 97299 ){
				print $0
			}
		}' > region_filtered.csv
	fi
	
	
	
	if [ ${Ot_bool} -eq 1 ]
	then
		echo date_filtered.csv | awk -f'[;]' '{
			if( $15 >= 97600 && $15 <= 97699 ){
				print $0
			}
			if( $15 >= 97400 && $15 <= 97499 ){
				print $0
			}
		}' > region_filtered.csv
	
	
		
	fi
	if [ ${Qt_bool} -eq 1 ]
		echo date_filtered.csv | awk -f'[;]' '{
			if( $15 >= 98400 && $15 <= 98499 ){
				print $0
			}
		}' > region_filtered.csv
	then
	fi
fi
#reunion maillote
fi


if [ ${dt_bool} -eq 0 ]
then
#FGSAOQ
#= France,Guyane,Stpier,Antille,Ocean Indien,Antartique
	if [ ${Ft_bool} -eq 1 ]
	then	

		if [ ${tt_bool} -eq 1 ]		#TRI DES STATIONS
		then
			cut -d';' -f1 meteo_filtered_data_v1.csv | sed 1d >stationid.txt	
			cut -d';' -f11,12,13 meteo_filtered_data_v1.csv | sed 1d >temp.txt	
			rm temp.txt
			rm stationid.txt
		fi
		if [ ${tt_bool} -eq 2 ]		#TRI DES COORDONNEES
		then
			cut -d';' -f1 meteo_filtered_data_v1.csv | sed 1d >coord.txt
			cut -d';' -f11,12,13 meteo_filtered_data_v1.csv | sed 1d >temp.txt
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
		f	i
		if [ ${pt_bool} -eq 3 ]
		then
			echo "coucou2"
		fi
		if [ ${ht_bool} -eq 1 ]
		then
			touch altitude.txt 
			cut -d';' -f14 meteo_filtered_data_v1.csv | sed 1d | >>altitude.txt
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
fi
	if [ ${Gt_bool} -eq 1 ]
	then	
	fi
	if [ ${St_bool} -eq 1 ]
	then	
	fi
	if [ ${At_bool} -eq 1 ]
	then
	fi
	if [ ${Ot_bool} -eq 1 ]
	then
	fi
	if [ ${Qt_bool} -eq 1 ]
	then
	fi
fi
comment

if [ ${dt_bool} -eq 0 ]
then
#FGSAOQ
#= France,Guyane,Stpier,Antille,Ocean Indien,Antartique
	if [ ${Ft_bool} -eq 1 ]
	then	
	fi
	if [ ${Gt_bool} -eq 1 ]
	then
	fi
	if [ ${St_bool} -eq 1 ]
	then
	fi
	if [ ${At_bool} -eq 1 ]
	then
	fi
	if [ ${Ot_bool} -eq 1 ]
	then
	fi
	if [ ${Qt_bool} -eq 1 ]
	then
	fi







if [ ${tt_bool} -eq 1 ]		#TRI DES STATIONS
then
	cut -d';' -f1 meteo_filtered_data_v1.csv | sed 1d >stationid.txt
	cut -d';' -f11,12,13 meteo_filtered_data_v1.csv | sed 1d >temp.txt
	rm temp.txt
	rm stationid.txt
fi
if [ ${tt_bool} -eq 2 ]		#TRI DES COORDONNEES
then
	cut -d';' -f1 meteo_filtered_data_v1.csv | sed 1d >coord.txt
	cut -d';' -f11,12,13 meteo_filtered_data_v1.csv | sed 1d >temp.txt
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
f	i
if [ ${pt_bool} -eq 3 ]
then
	echo "coucou2"
fi
if [ ${ht_bool} -eq 1 ]
then
	touch altitude.txt 
	cut -d';' -f14 meteo_filtered_data_v1.csv | sed 1d | >>altitude.txt
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
