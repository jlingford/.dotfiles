#!/usr/bin/env bash

# USAGE:
# labnote.sh [TITLE]

# take first command line argument
TITLE=$1

# find file with highest num prefix in current dir, return just the num
HIGHEST_NUM=$(fd -d1 "^[0-9]+" | tail -n 1 | sed -E 's/^([0-9]+)_.*/\1/')

# if no previous file, set number prefix to 00
if [[ -z $HIGHEST_NUM ]]; then
    HIGHEST_NUM="00"
fi

# increment for next number
NEXT_NUM=$((HIGHEST_NUM + 1))

# set new prefix for new file (requires printf for leading zeros)
FILE_PREFIX=$(printf "%02d" ${NEXT_NUM})

# set filename
FILENAME="${FILE_PREFIX}_${TITLE}_$(date -u +%Y%m%d).md"

# create new file
touch ${FILENAME}

echo "---
title: '${TITLE}'
author: 'James Lingford'
date: '$(date -u +%Y-%m-%d)'
toc: true
format:
    html:
        code-fold: true
        code-tools: true
        html-math-method: katex
        embed-resources: true
        theme:
            light: default
            dark: darkly
---

# ${TITLE}

" >>${FILENAME}
