V1

awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3" '
	  BEGIN{
	    split($2, d, "-");
	    split(d[3], t, "T");
	    split(t[2], h, ":");
	    if(d[1]>currdate_min1 && d[1]<currdate_max1) {
	    	print $0;
	    }
	    else if(d[1]==currdate_min1 || d[1]==currdate_max1) {
	    	if(d[2]>currddate_min2 && d[2]<currdate_max2) {
	    		print $0;
	    	}
	    	else if(d[2]==currddate_min2 && d[2]==currdate_max2) {
	    		if(t[1]>=currdate_min3 && t[1]<currdate_max3) {
	    			print $0;
	    		}
	    	}
	    }
	  }' meteo_filtered_data_v1.csv > date_filtered.csv

V2

awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3" '
	  BEGIN{
	    split($2, d, "-");
	    split(d[3], t, "T");
	    split(t[2], h, ":");
	    if(d[1]>currdate_min1 && d[1]<currdate_max1) {
	    	print $0;
	    }
	    else if(d[1]==currdate_min1 || d[1]==currdate_max1) {
	    	if(d[2]>currdate_min2 && d[2]<currdate_max2) {
	    		print $0;
	    	}
	    	else if(d[2]==currdate_min2 && d[2]==currdate_max2) {
	    		if(t[1]>=currdate_min3 && t[1]<currdate_max3) {
	    			print $0;
	    		}
	    	}
	    }
	  }' meteo_filtered_data_v1.csv > date_filtered.csv
	  
V3

awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3" '
	  BEGIN{
	    split($2, d, "-");
	    split(d[3], t, "T");
	    if(d[1] > currdate_min1 && d[1] < currdate_max1) {
	    	print $0;
	    }
	    else if(d[1] == currdate_min1 || d[1] == currdate_max1) {
	    	if(d[2] > currdate_min2 && d[2] < currdate_max2) {
	    		print $0;
	    	}
	    	else if(d[2] == currdate_min2 || d[2] == currdate_max2) {
	    		if(t[1] >= currdate_min3 && t[1] <= currdate_max3) {
	    			print $0;
	    		}
	    	}
	    }
	  }' meteo_filtered_data_v1.csv > date_filtered.csv
	  
V4

# Extract the csv file
csv_file="meteo_filtered_data_v1.csv"

# Create the output file
output_file="filtered_date.csv"

# Create the lower bound of the date comparison
curr_date_min=$curr_date_min_1"-"$curr_date_min_2"-"$curr_date_min_3"T"

# Create the upper bound of the date comparison
curr_date_max=$curr_date_max_1"-"$curr_date_max_2"-"$curr_date_max_3"T"

# Read the file line by line
while IFS= read -r line
do
    # Extract the date from the line
    date=$(echo $line | cut -d, -f2)
    # Check if the date is between the min and max
    if [[ $date > $curr_date_min && $date < $curr_date_max ]]; then
        # If it is, write the line to the output file
        echo "$line" >> $output_file
    fi
done < $csv_file
