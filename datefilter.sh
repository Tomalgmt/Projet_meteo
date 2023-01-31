awk -F';' -v start_date="$start_date" -v end_date="$end_date" '
BEGIN {
  split(start_date, start, "-");
  end_timestamp = mktime(end_date " 23 59 59");
  start_timestamp = mktime(start_date " 00 00 00");
}
{
  split($2, date, "T");
  curr_timestamp = mktime(date[1] " " substr(date[2],1,8));
  if (curr_timestamp >= start_timestamp && curr_timestamp <= end_timestamp) {
    print;
  }
}' input.csv > output.txt
