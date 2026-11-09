#!/usr/bin/env bash
# Job 3: ingresos por fila = cantidad * precio_unitario.
awk -F ',' '
$1 != "fecha" && NF >= 5 { print $2 "\t" ($4 * $5) }
'
