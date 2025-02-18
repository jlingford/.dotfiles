#!/usr/bin/env bash

# TODO - make output_dir option

# input and output
# output_dir=$2

# create new output dir if none exists
if [ ! -d formatted_fastas ]; then
    mkdir formatted_fastas
fi

# loop over all fasta files and reformat them
for file in "$@"; do
    awk 'NR==1 {printf ">" FILENAME "\n"} 1' ${file} |                                    # add file name as fasta header
        sed '1s/\.fasta//g' |                                                             # remove .fasta from fasta name
        awk '/^>/ {printf("\n%s\n",$0);next;} { printf("%s",$0);}  END {printf("\n");}' | # concatenate all amino acid seqs to a single line, (also creates white new lines above and below new fasta header!)
        sed '/^$/d' |                                                                     # delete empty lines
        sed '2,$s/^>.*$//g' |                                                             # remove all but the first fastas header
        sed '/^$/d' |                                                                     # delete empty lines
        sed 's/*//g' |                                                                    # remove any * from seqs
        sed 's/^\w.*$/&:/g' |                                                             # add : to end of all seqs
        sed '$s/://g' >"${file%.*}_AF2.fasta"                                             # remove : from last seq and output file
done

# move all reformatted fasta files to output_dir
mv ./*_AF2.fasta formatted_fastas
