#!/bin/bash

input_fasta=$1

cat $input_fasta | awk '{
    if (substr($0, 1, 1)==">") {filename=(substr($0,2) ".fasta")}
    print $0 > filename
    close(filename)
}'

# awk -F "|" '/^>/ {F = $2".fasta"} {print > F}' yourfile.fa
