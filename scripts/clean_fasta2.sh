#!/usr/env/bin bash

for file in *.fasta; do
    awk 'NR==1 {printf ">" FILENAME "\n"} 1' $file |
        awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' |
        sed '/^$/d' |
        sed '1s/\.fasta//g' |
        sed 's/*//g' |
        sed '2,$s/^>.*$//g' |
        sed '/^$/d' |
        sed 's/^\w.*$/&:/g' |
        sed '$s/://g' >${file%.*}_AF2.fasta
done

# cat Gerd_N.fasta | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | sed '/^$/d' | sed 's/*//g' | sed '2,$s/^>.*$//g' | sed '/^$/d' |  sed 's/^\w.*$/&:/g' | sed '$s/://g'
