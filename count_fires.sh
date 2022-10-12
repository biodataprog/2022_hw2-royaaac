#!/bin/bash -l

#command to download a file, but will actually use a different file to run the code because the downloaded file has many errors in it
curl -o calfires.csv https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::recent-large-fire-perimeters-5000-acres.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D

MINYEAR=`awk -F, '{print $2}' calfires_2021.csv | sort -n | sed '1d' | head -n 1` #using calfires_2021.csv because the formatting is verified
MAXYEAR=`awk -F, '{print $2}' calfires_2021.csv | sort -n | tail -n 1`

echo "This report has the years: $MINYEAR-$MAXYEAR" #prints out the range of years that fires 

TOTALFIRECOUNT=`cat calfires_2021.csv | sed '1d' | wc -l` 

echo "The total number of fires is: $TOTALFIRECOUNT" #prints out the total number of fires. This is equal to the number of rows, not including the header

echo "The number of fires in each year is as follows: "

awk -F, '{print $2}' calfires_2021.csv | sort -n | uniq -c | sed '1d'

LARGESTFIRE=`awk -F, '{print $13,$6,$2}' calfires_2021.csv | sort -nr | awk '{print $2, $3}' | head -n 1` 

LARGESTFIREYEAR=`awk -F, '{print $13,$6,$2}' calfires_2021.csv | sort -nr | awk '{print $4}' | head -n 1` 

echo "The largest fire, $LARGESTFIRE, burned in $LARGESTFIREYEAR" #prints out the name and year of the largest fire

for YEAR in `awk -F, '{print $2}' calfires_2021.csv | sort -n | uniq | sed '1d' `
do
TOTAL=`awk -F, '{print $2,$13}' calfires_2021.csv | sort -n | grep $YEAR | awk '{sum+=$2;} END{print sum;}'`
echo "In Year $YEAR, Total acreage burned was $TOTAL" #The Total acreage value is not correct because of errors in the source file, but the loop should work.
done
