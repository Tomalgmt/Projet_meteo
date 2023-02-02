awk -F ';' '{
  temperature_sum[$1] += $2
  temperature_min_sum[$1] += $3
  temperature_max_sum[$1] += $4
  temperature_count[$1]++
} END {
  for (station_id in temperature_sum) {
    temperature_avg = temperature_sum[station_id] / temperature_count[station_id]
    temperature_min_avg = temperature_min_sum[station_id] / temperature_count[station_id]
    temperature_max_avg = temperature_max_sum[station_id] / temperature_count[station_id]
    printf "%s;%.2f;%.2f;%.2f\n", station_id, temperature_avg, temperature_min_avg, temperature_max_avg
  }
}' $1
