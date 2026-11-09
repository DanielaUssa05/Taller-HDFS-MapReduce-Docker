#!/usr/bin/env bash
# Sumador para WordCount: Hadoop agrupa/sorta las claves del mapper.
awk -F '\t' '
NR == 1 { clave=$1; total=$2; next }
$1 == clave { total += $2; next }
{ print clave "\t" total; clave=$1; total=$2 }
END { if (NR > 0) print clave "\t" total }
'
