#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 input.fasta"
  exit 1
fi

input_file="$1"
output_dir="$2"

mkdir -p "$output_dir"

awk -v out="$output_dir" '
  BEGIN {
    # Initialize variables
    prev_seqname = ""
  }
  /^>/ {
    # Extract the sequence name
    seqname = substr($0, 2, 22)
    # Sanitize the sequence name for the file
    seqname = gensub(/[^a-zA-Z0-9]/, "_", "g", seqname)
    # Close the previous file if the sequence name changes
    if (seqname != prev_seqname && outfile) {
      close(outfile)
    }
    # Open (or append to) a file named after the current sequence
    outfile = seqname ".fasta"
    prev_seqname = seqname
  }
  {
    # Write the line to the appropriate file
    print $0 >> outfile
  }
' "$input_file"

mv *.fasta $output_dir
mv $output_dir/$input_file .

