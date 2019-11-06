#!/bin/bash

lab=$1
if [ -z "$lab" ]; then
  count=0
  for line in $(find lab*/*.marp.md); do
      (marp $line --pdf -o ${line%.marp.md}.pdf);
      count=$(($count+1));
  done;
  tput reset;
else
  marp $1 --pdf -o ${line%.marp.md}.pdf;
fi

printf "\nCompleted building %d files ...\n\n" $count;
