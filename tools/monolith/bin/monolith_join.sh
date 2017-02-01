#!/bin/bash

# monolith_join.sh <datafile_dest> <headerfile_dest> <datafile_src> <headerfile_src>

# it will be cool when you can put a list of databases.

datafile_dest=$1
headerfile_dest=$2
datafile_src=$3
headerfile_src=$4

if [ ! -f $datafile_src ]; then
  echo "error: $datafile_src does not exist" >&2
  exit 1
fi

if [ ! -f $headerfile_src ]; then
  echo "error: $headerfile_src does not exist" >&2
  exit 1
fi

if [ ! -f $datafile_dest ] && [ ! -f $headerfile_dest ]; then
  echo "creating new files $datafile_dest and $headerfile_dest" >&2
  touch $datafile_dest
  touch $headerfile_dest
fi
if [ -f "$datafile_dest" ] && [ -f "$headerfile_dest" ]; then
  # do some magic here
  # magic in process:
  # first, we have to adapt the index
  # funny step
  offsetadd=$(stat -c%s "$datafile_dest")
  #while IFS='' read -r line || [[ -n "$line" ]]; do
  #  filename=$( echo $line | awk '{print $1}')
  #  length=$( echo $line | awk '{print $3}')
  #  hash=$( echo $line | awk '{print $4}')
  #  offset=$( echo $line | awk '{print $2}')
  #  offset=$(( $offset + $offsetadd ))
  #  echo -e "$filename"'\t'"$offset"'\t'"$length"'\t'"$hash"
  #done < "$headerfile_src" >> "$headerfile_dest"
  awk '{ OFS = "\t" }; {$2=$2+'$offsetadd';print $1, $2, $3 ,$4}' $headerfile_src >> $headerfile_dest
  # then, we append the datasrc to datadest
  # easy step
  cat $datafile_src >> $datafile_dest
  # this is all the magic we need
else
  echo "error: only one of the destination files exist." >&2
fi


