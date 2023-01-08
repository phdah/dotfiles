#!/bin/bash

START=`date +%s`
TABLE=$1
LIMIT=$2

echo "Replicating $LIMIT lines of table $TABLE"

# Drop table
printf "Dropping table"
mysql -h barriers-1.clhgtkr8oj0b.eu-west-1.rds.amazonaws.com -u admin -pPerOchPaal -D landing -e "drop table if exists $TABLE;"
printf " - Done\n"

# Create table
printf "Recreating table"
printf "create table $TABLE (" > "cmd1_${TABLE}.txt" 
# TODO: select * | cut is not nice - select what we want instead
psql 'postgres://postgres:PerOchPaal@bruce.clhgtkr8oj0b.eu-west-1.rds.amazonaws.com:5432/bruce' -X -A -t -c\
  "select * from information_schema.columns where table_schema = 'ingestion' and table_name = '$TABLE';" \
  | cut -d '|' -f 4,8 | sed 's/|/ /' \
  | sed 's/bigint/integer/'\
  | sed 's/character varying/text/' \
  | sed 's/ time.*time zone/ text/' \
  | sed 's/jsonb/text/' \
  | sed 's/$/,/'\
  | tr -d '\n'\
  | sed 's/,$//' >> "cmd1_${TABLE}.txt"
printf ');\n' >> "cmd1_${TABLE}.txt"
mysql -h barriers-1.clhgtkr8oj0b.eu-west-1.rds.amazonaws.com -u admin -pPerOchPaal -D landing -e "$(cat cmd1_${TABLE}.txt)"
printf " - Done\n"

# Read
READ_START=`date +%s`
printf "Reading values"
psql 'postgres://postgres:PerOchPaal@bruce.clhgtkr8oj0b.eu-west-1.rds.amazonaws.com:5432/bruce' -A -t -c "select * from ingestion.$TABLE limit $LIMIT;" \
  | sed 's/{/"{/g' | sed 's/}/}"/g' > "values_${TABLE}.txt"
READ_END=`date +%s`
READ_SECONDS=$((READ_END-READ_START))
printf " - Done ($READ_SECONDS seconds)\n"

# Write
WRITE_START=`date +%s`
printf "Inserting values"
mysql -h barriers-1.clhgtkr8oj0b.eu-west-1.rds.amazonaws.com -u admin -pPerOchPaal -D landing \
  -e "LOAD DATA LOCAL INFILE 'values_${TABLE}.txt' INTO TABLE $TABLE FIELDS TERMINATED BY '|';"
WRITE_END=`date +%s`
WRITE_SECONDS=$((READ_END-READ_START))
printf " - Done ($WRITE_SECONDS seconds)\n"

END=`date +%s`

SECONDS=$((END-START))
echo "Replicated $LIMIT rows of table $TABLE in $SECONDS seconds, cleaning up"
printf "\n"
rm *_${TABLE}.txt
