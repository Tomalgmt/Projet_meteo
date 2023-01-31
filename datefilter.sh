awk -F';' -v start_date="$start_date" -v end_date="$end_date" '
BEGIN {
  split(start_date, start, "-");
  split(start[3], start_time, ",");
  split(start_time[2], start_clock, ":");
  split(end_date, end, "-");
  split(end[3], end_time, ",");
  split(end_time[2], end_clock, ":");
  start_timestamp = mktime(start[1] " " start[2] " " start_time[1] " " start_clock[1] " " start_clock[2] " " start_clock[3]);
  end_timestamp = mktime(end[1] " " end[2] " " end_time[1] " " end_clock[1] " " end_clock[2] " " end_clock[3]);
}
{
  split($2, date, "-");
  split(date[3], curr_time, ",");
  split(curr_time[2], curr_clock, ":");
  curr_timestamp = mktime(date[1] " " date[2] " " curr_time[1] " " curr_clock[1] " " curr_clock[2] " " curr_clock[3]);
  if (curr_timestamp >= start_timestamp && curr_timestamp <= end_timestamp) {
    print;
  }
}' input.csv > output.txt
