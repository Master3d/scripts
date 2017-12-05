#!/bin/bash

### Check a file for occurrence of errors or keywords, specified as 2nd argument
file=$1
[[ ! -f $1 ]] && echo "WARNING - File $1 is not valid" && exit 3
keyword=$2

### Threshold in seconds
warn=$3
crit=$4

lines=$5

[[ -z $3 ]] && echo "UNKNOWN - Please specify Warn and Crit thresholds (in seconds)" && exit 3
[[ -z $4 ]] && echo "UNKNOWN - Please specify Warn and Crit thresholds (in seconds)" && exit 3

# Find occurrences
occurrences=$(tail -${lines} $file | grep -c -e $keyword)

# Test values against thresholds
if [[ $occurrences -lt $warn ]]
then
    echo "OK - Found $occurrences occurrences"
    exit 0
elif [[ $occurrences -ge $warn ]] && [[ $occurrences -lt $crit ]]
then
    echo "WARNING - found $occurrences occurrences in the last $lines lines"
    exit 1
elif [[ $occurrences -ge $crit ]]
then
    echo "CRITICAL - found $occurrences occurrences in the last $lines lines"
    exit 2
else
    echo "UNKNOWN - found $occurrences occurrences in the last $lines lines"
    exit 3
fi
