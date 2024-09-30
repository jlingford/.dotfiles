#!/bin/bash

# provide the input fasta file and the name of the output fasta file.
# e.g. join_fasta.sh input.faa output.fasta
# will join all lines of amino acids into one line. will not join lines starting with >

input_fasta="$1"
output_fasta="$2"

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' $input_fasta > $output_fasta

# Check if the input file is provided
# if [ -z "$1" ]; then
#   echo "Usage: $0 input.fasta output.fasta"
#   exit 1
# fi
#
# input_file="$1"
# output_file="$2"
#
# awk '
#   BEGIN {
#     # Initialize an empty sequence string
#     seq = ""
#   }
#   /^>/ {
#     # Print the previous sequence if not empty
#     if (seq != "") {
#       print seq > output_file
#     }
#     # Print the header
#     print $0 > output_file
#     # Reset the sequence string
#     seq = ""
#   }
#   /^[^>]/ {
#     # Append the sequence line to the sequence string
#     seq = seq $0
#   }
#   END {
#     # Print the last sequence
#     if (seq != "") {
#       print seq > output_file
#     }
#   }
# ' output_file="$output_file" "$input_file"
#
