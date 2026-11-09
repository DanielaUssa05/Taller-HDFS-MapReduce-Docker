#!/usr/bin/env bash
# Job 2: obtener (categoria,precio_unitario,1) del CSV de ventas.
awk -F ',' '
$1 != "fecha" && NF >= 5 { print $3 "\t" $5 "\t1" }
'
