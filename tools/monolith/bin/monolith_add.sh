#!/bin/bash

#
# Monolith v0.1
#



# add a file or a file list to a datafile
# how to use this
# monolith_add.sh <datafile> <headerfile> <file1> [<file2> [<file3>....]]]



datafile=$1
headerfile=$2
if [ ! -f $datafile ]; then
  touch $datafile
fi

if [ ! -f $headerfile ]; then
  touch $headerfile
fi
args=( "$@" )
for newfile in ${args[@]:2}; do
  if [ ! -f $newfile ]; then
    echo "$newfile does not exist. aborting..." >&2
    exit 1
  fi
  offset=$(stat -c%s "$datafile")
  length=$(stat -c%s "$newfile")
  hash=$(md5sum $newfile | awk '{print $1}')
  cat $newfile >> $datafile
  echo -e "$newfile"'\t'"$offset"'\t'"$length"'\t'"$hash"
done >> $headerfile
