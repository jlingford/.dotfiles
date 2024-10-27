#!/usr/bin/env bash

# USAGE:
# labnote [TITLE]

TITLE=$1

touch "$TITLE"_$(date -u +%Y%m%d).md

echo "---
title: '$TITLE'
author: 'James Lingford'
date: '$(date -u +%Y-%m-%d)'
toc: true
format:
    html:
        code-fold: true
        code-tools: true
        html-math-method: katex
---

# $TITLE

" >>"$TITLE"_$(date -u +%Y%m%d).md
