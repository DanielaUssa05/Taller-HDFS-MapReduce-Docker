#!/usr/bin/env bash
# Un reducer agrega ventas por producto y ordena los totales de forma descendente.
awk -F '\t' '
{ ventas[$1]+=$2 }
END { for (producto in ventas) printf "%s\t%.0f\n", producto, ventas[producto] }
' | sort -k2,2nr | head -n 3
