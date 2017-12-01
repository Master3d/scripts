#!/bin/bash

# Parse first 2 arguments
# $1 is for warnign threshold
# $2 is for critical
warn=$1
crit=$2

# Collect memory statistics
mem_stats=$(free | grep Mem)
mem_total=$(free | grep Mem | awk '{print $2}')
mem_used=$(free | grep Mem | awk '{print $3}')
mem_free=$(free | grep Mem | awk '{print $4}')

# Generate output
output="Memory stats: $mem_stats | Total=$mem_total, User=$mem_used, Free=$mem_free"

# Test values against thresholds
if [ $mem_free -gt $warn ]
then
    echo "OK- $output"
    exit 0
elif [ $mem_free -le $warn -a $mem_free -gt $crit ]
then
    echo "WARNING- $output"
    exit 1
elif [ $mem_free -lt $crit ]
then
    echo "CRITICAL- $output"
    exit 2
else
    echo "UNKNOWN- $output"
    exit 3
fi
