#!/bin/bash

number=$1

if ((number % 15 == 0)); then
    echo "tomcat"
elif ((number % 3 == 0)); then
    echo "tom"
elif ((number % 5 == 0)); then
    echo "cat"
else
    echo "$number"
fi

