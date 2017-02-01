#!/bin/bash

# monolith_get <datafile> <headerfile> <-f filename | -h md5sum | -l linenumber | -o offset> [-O]
# right now, lets put only the name...
# -O is for overwrite.

datafile=$1
headerfile=$2
filename=$3


if [ ! -f "$datafile" ]; then
  echo "$datafile does not exist.">&2
  exit 1
fi
if [ ! -f "$headerfile" ]; then
  echo "$headerfile does nott exist" >&2
  exit 1
fi
if [ -f $filename ]; then
  echo "$filename exists, and this is only a test. so i don't handle this. bye." >&2
  exit 1
fi

args=( "$@" )
for i in  ${args[@]:2}; do
  grepflags="$grepflags -e $i"
done
echo $grepflags
grep $grepflags $headerfile |  while IFS='' read -r line || [[ -n "$line" ]]; do
  innername=$( echo $line | awk '{print $1}')
  offset=$( echo $line | awk '{print $2}')
  length=$( echo $line | awk '{print $3}')
  md5sum=$( echo $line | awk '{print $4}')
  echo $innername >&2
  if [ "$(echo $innername | grep '/')" != "" ]; then
    filepath=${innername%/*}
    echo "folder tree found, creating folder $filepath" >&2
    mkdir -p $filepath
  fi
  dd if=$datafile of=$innername bs=1 skip=$offset count=$length
  if [ "$md5sum" != "$( md5sum $filename | awk '{print $1}')" ]; then
    echo "Warning: file checksums differ..." >&2
  fi
done
