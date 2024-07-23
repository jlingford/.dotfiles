#!/usr/bin/awk -f

/^>/ {
    # Extract the sequence name
    seqname = substr($0, 2, 10)
    # Replace any characters that might be problematic in filenames
    gsub(/[^a-zA-Z0-9]/, "_", seqname)
    # Close the previous file if it exists
    if (outfile) {
        close(outfile)
    }
    # Open a new file for the current sequence
    outfile = seqname ".fasta"
}

{
    # Write the current line to the appropriate file
    print $0 > outfile
}

#!/usr/bin/awk -f

/^>/ {
    # Extract the sequence name
    seqname = substr($0, 2)
    # Replace any characters that might be problematic in filenames
    gsub(/[^a-zA-Z0-9]/, "_", seqname)
    # Close the previous file if it's a different sequence name
    if (seqname != prev_seqname && outfile) {
        close(outfile)
    }
    # Open a new file for the current sequence if it's a new sequence name
    outfile = seqname ".fasta"
    prev_seqname = seqname
}

{
    # Write the current line to the appropriate file
    print $0 >> outfile
}

#!/bin/bash

# Check if the input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 input.fasta"
  exit 1
fi

input_file="$1"

awk '
  BEGIN {
    # Initialize variables
    prev_seqname = ""
  }
  /^>/ {
    # Extract the sequence name
    seqname = substr($0, 2)
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

