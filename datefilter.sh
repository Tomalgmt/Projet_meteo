awk -F';' -v start_date="$start_date" -v end_date="$end_date" '
BEGIN {
  split(start_date, start, "-");
  end_date = end_date " 23:59:59+0000";
  split(end_date, end, "-");
  start_timestamp = mktime(start[1] " " start[2] " " start[3] " 00 00 00");
  end_timestamp = mktime(end[1] " " end[2] " " end[3] " 23 59 59");
}
{
  split($2, date, "T");
  split(date[1], curr, "-");
  curr_timestamp = mktime(curr[1] " " curr[2] " " curr[3] " " date[2]);
  if (curr_timestamp >= start_timestamp && curr_timestamp <= end_timestamp) {
    print;
  }
}' input.csv > output.txt
