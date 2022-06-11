#!/bin/sh

access_file=
type=$(head -n 1 $access_file)
connection=$(head -n 2 $access_file | tail -n 1)
database=$(head -n 3 $access_file | tail -n 1)
user=$(head -n 4 $access_file | tail -n 1)
pass=$(tail -n 1 $access_file)

sql2csv --db $type://$user:$pass@$connection/$database --query "$1"
