declare -A temperature_sum
declare -A temperature_min_sum
declare -A temperature_max_sum
declare -A count

# Read each line of the input file
while read line; do
  # Extract the values for station ID, temperature, temperature minimum, and temperature maximum
  stationID=$(echo $line | awk -F "," '{print $1}')
  temperature=$(echo $line | awk -F "," '{print $11}')
  temperature_min=$(echo $line | awk -F "," '{print $12}')
  temperature_max=$(echo $line | awk -F "," '{print $13}')

  # Increment the count of occurrences of this station ID
  count[$stationID]=$((count[$stationID]+1))

  # Add the temperature, temperature minimum, and temperature maximum to the sum for this station ID
  temperature_sum[$stationID]=$((temperature_sum[$stationID]+temperature))
  temperature_min_sum[$stationID]=$((temperature_min_sum[$stationID]+temperature_min))
  temperature_max_sum[$stationID]=$((temperature_max_sum[$stationID]+temperature_max))
done < region_filtered.csv

# Open the output file for writing
exec 3>temp_filtered.csv

# Write the header line to the output file
echo "stationID;temperature;temperature_min;temperature_max" >&3

# Calculate the average temperature, temperature minimum, and temperature maximum for each unique station ID
for stationID in "${!count[@]}"; do
  temperature_avg=$((temperature_sum[$stationID]/count[$stationID]))
  temperature_min_avg=$((temperature_min_sum[$stationID]/count[$stationID]))
  temperature_max_avg=$((temperature_max_sum[$stationID]/count[$stationID]))

  # Write the results to the output file
  echo "$stationID;$temperature_avg;$temperature_min_avg;$temperature_max_avg" >&3
done

# Close the output file
exec 3>&-


V2

# Calculate average temperature, temperature minimum, and temperature maximum
# for each station ID and write the result to the output file
awk -F "," '{
  temperatures[$1]+=$11;
  temperature_mins[$1]+=$12;
  temperature_maxs[$1]+=$13;
  counts[$1]++;
}
END {
  for (station in temperatures) {
    printf("%s,%.2f,%.2f,%.2f\n", station, temperatures[station]/counts[station], temperature_mins[station]/counts[station], temperature_maxs[station]/counts[station]) >> output;
  }
}' "$file"
