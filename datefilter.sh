date_part1="2011-5-12"
date_part2="2013-5-6"

awk -F';' -v date1="$date_part1" -v date2="$date_part2" '
  BEGIN{
    split(date1, d1, "-");
    split(date2, d2, "-");
    t1=mktime(d1[1] " " d1[2] " " d1[3] " 00 00 00");
    t2=mktime(d2[1] " " d2[2] " " d2[3] " 23 59 59");
  }
  {
    split($2, d, "-");
    split(d[3], t, "T");
    split(t[2], h, "+");
    split(h[1], m, ":");
    t3=mktime(d[1] " " d[2] " " t[1] " " m[1] " " m[2] " " m[3]);
    if(t3>=t1 && t3<=t2) {
      print $0;
    }
  }
' input.csv > output.csv
