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

	awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3" -v a="cut -d'-' -f1 $2" -v b="cut -d'-' -f1 $2" -v c="cut -d'-' -f1 $2 |cut -d'T' -f1"'
	BEGIN {
  	  if (a > currdate_min1 && a < currdate_max1) {
  	      print $0;
  	  }
  	  else {
  	      if (a == currdate_min1 || a == currdate_max1) {
  	          if (b > currdate_min2 && b < currdate_max2) {
  	              print $0;
  	          }
  	      }
  	      else {
  	          if (b == currdate_min2 || b == currdate_max2) {
  	              if (c >= currdate_min3 && c <= currdate_max3) {
  	                  print $0;
  	              }
  	          }
  	      }
  	  }
	}' meteo_filtered_data_v1.csv > date_filtered.csv
	
V5	
	
awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3" -v a="$(cut -d'-' -f1 $2)" -v b="$(cut -d'-' -f1 $2)" -v c="$(cut -d'-' -f1 $2 |cut -d'T' -f1)" 'BEGIN {
  if (a > currdate_min1 && a < currdate_max1) {
      print $0;
  }
  else {
      if (a == currdate_min1 || a == currdate_max1) {
          if (b > currdate_min2 && b < currdate_max2) {
              print $0;
          }
      }
      else {
          if (b == currdate_min2 || b == currdate_max2) {
              if (c >= currdate_min3 && c <= currdate_max3) {
                  print $0;
              }
              if(c==currdate_min3 && c<currdate_max3){
                  print $0;
              }
          }
      }
  }
}' meteo_filtered_data_v1.csv > date_filtered.csv

V6
	awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3"'BEGIN {
		a=substr($2,1,index($2,"-")-1);
		b=substr($2,2,index($2,"-")-1);
		c=substr($2,3,index($2,"-")-1);
		if (a > currdate_min1 && a < currdate_max1) {
      			print $0;
 		 }
 		 else {
      			if (a == currdate_min1 || a == currdate_max1) {
      			    if (b > currdate_min2 && b < currdate_max2) {
      			        print $0;
     			     }
      			}
     			else {
     			     if (b == currdate_min2 || b == currdate_max2) {
           			   if (c >= currdate_min3 && c <= currdate_max3) {
               				   print $0;
      					}
           			   if(c==currdate_min3 && c<currdate_max3){
           			       print $0;
          			    }
         			}
      			}
  		}
	}' meteo_filtered_data_v1.csv > date_filtered.csv

V7

	awk -F';' -v currdate_min1="$currdatemin_1" -v currdate_min2="$currdatemin_2" -v currdate_min3="$currdatemin_3" -v currdate_max1="$currdatemax_1" -v currdate_max2="$currdatemax_2" -v currdate_max3="$currdatemax_3"'
	BEGIN {
		split($2,d,";");
		split(d[2],t,"T");
		split(t[1],p,"-");
		print t[1];
		if (a > currdate_min1 && a < currdate_max1) {
      			print $0;
 		 }
 		 else {
      			if (a == currdate_min1 || a == currdate_max1) {
      			    if (b > currdate_min2 && b < currdate_max2) {
      			        print $0;
     			     }
      			}
     			else {
     			     if (b == currdate_min2 || b == currdate_max2) {
           			   if (c >= currdate_min3 && c <= currdate_max3) {
               				   print $0;
      					}
           			   if(c==currdate_min3 && c<currdate_max3){
           			       print $0;
          			    }
         			}
      			}
  		}
	}' meteo_filtered_data_v1.csv >>date_filtered.csv
