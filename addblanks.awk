/^[[:blank:]]*#/ {next} # ignore comments (lines starting with #)
NF < 2 {next} # ignore lines which don't have at least 3 columns
$1 != prev {printf "\n"; prev=$1} # print blank line
{print} # print the line
