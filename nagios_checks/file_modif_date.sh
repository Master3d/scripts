cat file_modif_date.sh
#!/bin/bash

### Check a file's last modification date
file=$1
[[ ! -f $1 ]] && echo "WARNING - File $1 is not valid" && exit 3

### Threshold in seconds
warn=$2
crit=$3

[[ -z $2 ]] && echo "UNKNOWN - Please specify Warn and Crit thresholds (in seconds)" && exit 3
[[ -z $3 ]] && echo "UNKNOWN - Please specify Warn and Crit thresholds (in seconds)" && exit 3

# Calculate times
time_now=$(date +%s)
file_date=$(stat -c %Y $file)
diff=$((time_now - file_date))
#output="Modified $diff sec. ago"
time_past=$(printf '%dh:%dm:%ds\n' $(($diff/3600)) $(($diff%3600/60)) $(($diff%60)))
output="Modified $time_past ago"

# Test values against thresholds
if [[ $diff -lt $warn ]]
then
    echo "OK - $output"
    exit 0
elif [[ $diff -ge $warn ]] && [[ $diff -lt $crit ]]
then
    echo "WARNING - $output"
    exit 1
elif [[ $diff -gt $crit ]]
then
    echo "CRITICAL - $output"
    exit 2
else
    echo "UNKNOWN - $output"
    exit 3
fi
