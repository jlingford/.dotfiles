#!/usr/bin/env bash

# usage: af2_fasta_format.sh <OUTPUT>
# e.g. af2_fasta_format.sh output_dir

# input and output
output_dir=$1

# loop over all fasta files and reformat them
for file in ./*.fasta; do
    awk 'NR==1 {printf ">" FILENAME "\n"} 1' ${file} |                                     # add file name as fasta header
        sed '1s/\.fasta//g' |                                                              # remove .fasta from fasta name
        awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | # concatenate all amino acid seqs to a single line
        sed 's/*//g' |                                                                     # remove any * from seqs
        sed '2,$s/^>.*$//g' |                                                              # remove all but the first fastas header
        sed '/^$/d' |                                                                      # delete empty lines
        sed 's/^\w.*$/&:/g' |                                                              # add : to end of all seqs
        sed '$s/://g' >${file%.*}_AF2.fasta                                                # remove : from last seq and output file
done

# create new output dir if none exists
if [ ! -d ${output_dir} ]; then
    mkdir ${output_dir}
fi

# move all reformatted fasta files to output_dir
mv ./*_AF2.fasta ${output_dir}
