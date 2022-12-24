#!/bin/sh

#########################################################################
#                               PREREQUISITES                           #
#########################################################################
# 1. csvkit

#########################################################################
#                               INSTRUCTIONS                            #
#########################################################################
# - Create a file with the database access data with this line structure:
#   1. Type of databse (postgresql, mysql, sqllite...)
#   2. Connection parameters (Ex: localhost@3308)
#   3. Database name (Ex: mysqldatabase)
#   4. User name (Ex: myuser)
#   5. Password ( Ex: mypassword)

access_file=$1
type=$(head -n 1 $access_file)
connection=$(head -n 2 $access_file | tail -n 1)
database=$(head -n 3 $access_file | tail -n 1)
user=$(head -n 4 $access_file | tail -n 1)
pass=$(tail -n 1 $access_file)
query=$(while read line
do
  echo "$line"
done < "${2:-/dev/stdin}")

sql2csv --db $type://$user:$pass@$connection/$database --query "$query"
