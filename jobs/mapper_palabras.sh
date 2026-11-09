#!/usr/bin/env bash
# Job 1: transformar cada palabra en la pareja palabra,1.
awk '{
  for (i=1; i<=NF; i++) {
    palabra=tolower($i)
    gsub(/[^[:alnum:]_]/, "", palabra)
    if (palabra != "") print palabra "\t1"
  }
}'
