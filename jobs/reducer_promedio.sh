#!/usr/bin/env bash
# Reducir por categoria y sacar el promedio de precios unitarios.
awk -F '\t' '
NR == 1 { categoria=$1 }
NR > 1 && $1 != categoria {
  printf "%s\t%.2f\n", categoria, suma / cantidad
  suma=0; cantidad=0; categoria=$1
}
{ suma += $2; cantidad += $3 }
END { if (NR > 0 && cantidad > 0) printf "%s\t%.2f\n", categoria, suma / cantidad }
'
