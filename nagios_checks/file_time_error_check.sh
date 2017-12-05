#!/bin/bash

show_help() {
        echo ""
        echo "$0"
        echo "Simple Nagios Plugin, to check in a logfile"
        echo "if there are a certain number of occurrences"
        echo "in the last amount of seconds"
        echo ""
        echo "Filename, keyword to match, interval and warn/crit thresolds"
        echo "have to be provided as parameters."
        echo ""
        echo "$0 Required parameters:"
        echo "  --file|-f)"
        echo "    Log file to analyze"
        echo "  --keyword|-k)"
        echo "    Word or expression to match (please enclose regex in single quotes '' "
        echo "  --seconds|-s)"
        echo "    Interval of past time, in seconds, until the actual time"
        echo "  --warning|-w)"
        echo "    Sets a warning level for CPU user. Default is: off"
        echo "  --critical|-c)"
        echo "    Sets a critical level for CPU user. Default is: off"
        exit 0
}


### Collect input parameters

while test -n "$1"; do
    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        --file|-f)
            file=$2
            shift
            ;;
        --keyword|-k)
            keyword=$2
            shift
            ;;
        --seconds|-s)
            seconds_past=$2
            shift
            ;;
        --warning|-w)
            warn=$2
            shift
            ;;
        --critical|-c)
            crit=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            show_help
            exit 0
            ;;
    esac
    shift
done

[[ ! -f $file ]] && echo "WARNING - File $file is not valid" && exit 3

# Calculate times
time_now=$(date +%H:%M:%S)
time_past=$(date --date="$seconds_past seconds ago" +%H:%M:%S)


# Find occurrences
#occurrences=$(awk -F'[][]' -v last=$last -v seconds_past=$seconds_past '{ gsub(/\//," ",$2); sub(/:/," ",$2); "date +%s -d \""$2"\""|getline d; if (last-d<=x)print $0 }' $file | grep -c -e $keyword)
occurrences=$(sed -n '/'$time_past'/,/'$time_now'/p' $file | grep -c -e $keyword)

# Test values against thresholds
if [[ $occurrences -lt $warn ]]
then
    echo "OK - Found $occurrences occurrences"
    exit 0
elif [[ $occurrences -ge $warn ]] && [[ $occurrences -lt $crit ]]
then
    echo "WARNING - found $occurrences occurrences in the last $seconds_past seconds"
    exit 1
elif [[ $occurrences -ge $crit ]]
then
    echo "CRITICAL - found $occurrences occurrences in the last $seconds_past seconds"
    exit 2
else
    echo "UNKNOWN - found $occurrences occurrences in the last $seconds_past seconds"
    exit 3
fi
