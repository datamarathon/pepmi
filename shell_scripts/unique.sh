#!/bin/sh

# http://www.staff.science.uu.nl/~oostr102/docs/nawk/nawk_23.html
# http://unix.stackexchange.com/questions/91032/uniq-a-csv-file-ignoring-a-column-awk-maybe
# awk -F, -vOFS=, '{l=$0; $3=""}; ! ($0 in seen) {print l; seen[$0]}'

cat ~/mimic2/_filtered_files/CHARTEVENTS_RR.txt | awk '{FS=","} ; !seen[$2]++ { print $2","$4","$10}' | sed -e '1d' > ~/mimic2/_filtered_files/CHARTEVENTS_RR_nondup.txt

