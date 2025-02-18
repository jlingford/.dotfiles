#!/bin/bash

# remove comments at end of fasta names
sed -i 's/\s.*$//g' *.fasta

# replace - with _
sed -i 's/-/_/g' *.fasta

# remove all but the first fasta name with >
sed -i '2,$s/^>.*$//g' *.fasta

# delete empty lines
sed -i '/^$/d' *.fasta

# remove any * at end of sequences
sed -i 's/*//g' *.fasta

# add : to end of all sequences
sed -i 's/^\w.*$/&:/g' *.fasta

# remove : from last sequence
sed -i '$s/://g' *.fasta

# add name of file to top of fasta file
awk 'NR==1 {printf ">" FILENAME "\n"} 1' *.fasta > 

# get only names of outputs
# ls -l output/NuoEFG_test1/*.pdb | awk -F "/" '{print $3}' | sed -E 's/_unrelaxed.*$//g'

# join lines in fasta file. only use if a single sequence
# sed -n '2,$p' *.fasta | tr -d '\n'
#
# cat Gerd_N.fasta | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | sed '/^$/d' | sed 's/*//g' | sed '2,$s/^>.*$//g' | sed '/^$/d' |  sed 's/^\w.*$/&:/g' | sed '$s/://g'

