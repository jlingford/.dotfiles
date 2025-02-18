#!/usr/bin/env bash

# usage: monomers2dimers_fastas.sh <INPUT> <OUTPUT>
# eg. monomers2dimers_fastas.sh *.fasta output_dir

# set input and output
input_files=$1
output_dir=$2

for file in ${input_files}; do

    # set name of output
    name="${file##*/}"
    output_file="${output_dir}"/"${name%.*}_dimer.${name##*.}"

    # awk
    awk 'BEGIN{ RS=""; FS="\n" }{ printf "%s\n%s:\n%s", $1,$2,$2}' "${file}" >"${output_file}"

done
