
# Taller práctico: Exploración de HDFS y Hadoop MapReduce con Docker

**Profesor:** Heberth Martínez  
**Fecha:** 9 de noviembre de 2026  
**Herramientas:** Docker Desktop, Docker Compose, Apache Hadoop 3.2.1, HDFS, YARN y Hadoop MapReduce.

---

## 1. Descripción del proyecto

Este proyecto corresponde al taller práctico de exploración de HDFS y Hadoop MapReduce utilizando Docker.

El propósito es comprender cómo funciona un sistema de almacenamiento distribuido, ejecutar trabajos de procesamiento de datos y evaluar el comportamiento del clúster frente a fallos controlados.

Para desarrollar la práctica se implementó un clúster local de Hadoop compuesto por seis servicios, utilizando Docker Compose.

Se realizaron tres trabajos MapReduce:

1. **WordCount:** conteo de palabras.
2. **Promedio por categoría:** cálculo del precio promedio de productos.
3. **Top 3 de productos:** identificación de los productos con mayores ingresos.

También se utilizaron las interfaces web de HDFS y YARN para verificar los servicios, los resultados de las aplicaciones y su ejecución.

Finalmente, se realizó una prueba controlada de tolerancia a fallos deteniendo temporalmente un DataNode.

---

## 2. Tecnologías utilizadas

| Tecnología | Descripción |
|---|---|
| Docker Desktop | Plataforma utilizada para ejecutar los contenedores. |
| Docker Compose | Herramienta para desplegar y administrar los servicios del clúster. |
| Apache Hadoop 3.2.1 | Framework utilizado para el almacenamiento y procesamiento distribuido. |
| HDFS | Sistema de archivos distribuido de Hadoop. |
| YARN | Administrador de recursos y ejecución de aplicaciones. |
| MapReduce | Modelo de procesamiento distribuido de datos. |
| Hadoop Streaming | Permite ejecutar Mapper y Reducer mediante scripts. |
| Bash y AWK | Herramientas utilizadas para implementar la lógica de procesamiento. |
| Visual Studio Code | Editor utilizado para desarrollar y ejecutar el proyecto. |

---

## 3. Arquitectura del clúster

El clúster está compuesto por los siguientes servicios:

| Servicio | Función |
|---|---|
| NameNode | Administra los metadatos y la ubicación de los bloques de HDFS. |
| DataNode 1 | Almacena bloques de información. |
| DataNode 2 | Almacena bloques y permite mantener réplicas. |
| ResourceManager | Coordina los recursos disponibles en YARN. |
| NodeManager | Gestiona la ejecución de las tareas. |
| HistoryServer | Permite consultar información histórica de los trabajos MapReduce. |

La configuración de HDFS utiliza un factor de replicación de 2, permitiendo almacenar copias de los bloques en los DataNodes disponibles.

---

## 4. Estructura del proyecto

```text
taller-hdfs-proyecto/
│
├── docker-compose.yml
├── hadoop.env
├── README.md
├── INFORME_PARA_COMPLETAR.md
│
├── data/
│   ├── palabras.txt
│   └── ventas.csv
│
├── jobs/
│   ├── mapper_palabras.sh
│   ├── reducer_suma.sh
│   ├── mapper_promedio.sh
│   ├── reducer_promedio.sh
│   ├── mapper_top3.sh
│   └── reducer_top3.sh
│
└── evidencias/
    ├── 01_contenedores.png
    ├── 02_datanodes_reporte.png
    ├── 03_namenode.png
    ├── 04_archivos_hdfs.png
    ├── 05_wordcount_resultado.png
    ├── 06_wordcount_yarn.png
    ├── 07_promedio_resultado.png
    ├── 08_promedio_yarn.png
    ├── 09_top3_resultado.png
    ├── 10_top3_yarn.png
    ├── 11_tres_jobs_yarn.png
    ├── 12_logs_wordcount.png
    ├── 13_logs_promedio.png
    ├── 14_logs_top3.png
    ├── 15_antes_fallo.png
    ├── 16_datanode_detenido.png
    ├── 17_lectura_durante_fallo.png
    ├── 18_estado_durante_fallo.png
    └── 19_datanode_recuperado.png
```

**Descripción de las carpetas:**

- `data/`: contiene los archivos utilizados como entrada de los trabajos.
- `jobs/`: contiene los programas Mapper y Reducer.
- `evidencias/`: contiene las capturas de las actividades realizadas.
- `docker-compose.yml`: define los servicios del clúster.
- `hadoop.env`: contiene la configuración de HDFS, YARN y MapReduce.
- `INFORME_PARA_COMPLETAR.md`: contiene el desarrollo y análisis de la práctica.

---

## 5. Requisitos para ejecutar el proyecto

Para ejecutar el laboratorio se necesita:

- Windows con WSL 2.
- Docker Desktop funcionando con contenedores Linux.
- Docker Compose.
- Visual Studio Code o una terminal PowerShell.
- Memoria RAM suficiente para ejecutar los servicios de Hadoop.

Las imágenes utilizadas corresponden a Hadoop 3.2.1 del proyecto Big Data Europe.

---

## 6. Instrucciones de ejecución

### 6.1. Verificar Docker

Abrir Docker Desktop y comprobar que su motor esté funcionando.

Después, ejecutar:

```powershell
docker --version
docker compose version
docker info
```

### 6.2. Iniciar el clúster

Desde la carpeta principal del proyecto ejecutar:

```powershell
docker compose up -d
```

Verificar los servicios:

```powershell
docker compose ps
```

Se espera encontrar los siguientes contenedores:

- taller-namenode
- taller-datanode1
- taller-datanode2
- taller-resourcemanager
- taller-nodemanager
- taller-historyserver

### 6.3. Comprobar los DataNodes

Ejecutar:

```powershell
docker exec taller-namenode hdfs dfsadmin -report
```

El objetivo es comprobar que HDFS reconozca los dos DataNodes.

---

## 7. Interfaces web

Las interfaces del clúster se pueden consultar mediante las siguientes direcciones:

| Servicio | Dirección |
|---|---|
| HDFS NameNode | http://localhost:9870 |
| YARN ResourceManager | http://localhost:8088 |
| NodeManager | http://localhost:8042 |
| HistoryServer | http://localhost:19888 |

Estas interfaces permiten consultar el estado de los servicios y los trabajos ejecutados.

---

## 8. Carga de archivos en HDFS

Se utilizaron dos archivos de prueba:

**palabras.txt:** contiene palabras relacionadas con motocicletas y repuestos.

**ventas.csv:** contiene registros simulados de productos, categorías, cantidades y precios.

### Crear el directorio

```powershell
docker exec taller-namenode hdfs dfs -mkdir -p /taller/input
```

### Subir los archivos

```powershell
docker exec taller-namenode hdfs dfs -put -f /data/palabras.txt /taller/input/
```

```powershell
docker exec taller-namenode hdfs dfs -put -f /data/ventas.csv /taller/input/
```

### Verificar la carga

```powershell
docker exec taller-namenode hdfs dfs -ls /taller/input
```

Consultar el contenido:

```powershell
docker exec taller-namenode hdfs dfs -cat /taller/input/ventas.csv
```

---

## 9. Trabajos MapReduce

Se implementaron tres trabajos mediante Hadoop Streaming, utilizando scripts Bash y AWK.

### 9.1. Job 1: WordCount

**Objetivo:** contar la frecuencia de las palabras almacenadas en `palabras.txt`.

**Mapper:** `mapper_palabras.sh`  
**Reducer:** `reducer_suma.sh`

**Comando de ejecución:**

```powershell
docker exec taller-namenode hadoop jar /opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar -D mapreduce.job.reduces=1 -files /jobs/mapper_palabras.sh,/jobs/reducer_suma.sh -input /taller/input/palabras.txt -output /taller/output/palabras -mapper "bash mapper_palabras.sh" -reducer "bash reducer_suma.sh"
```

**Consultar el resultado:**

```powershell
docker exec taller-namenode hdfs dfs -cat /taller/output/palabras/part-*
```

**Resultados esperados:**

| Palabra | Frecuencia |
|---|---:|
| aceite | 3 |
| filtro | 2 |
| freno | 2 |
| moto | 3 |

**Estado verificado en YARN:** SUCCEEDED.

---

### 9.2. Job 2: Promedio de precios por categoría

**Objetivo:** calcular el promedio simple de los precios unitarios agrupados por categoría.

**Mapper:** `mapper_promedio.sh`  
**Reducer:** `reducer_promedio.sh`

**Comando de ejecución:**

```powershell
docker exec taller-namenode hadoop jar /opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar -D mapreduce.job.reduces=1 -files /jobs/mapper_promedio.sh,/jobs/reducer_promedio.sh -input /taller/input/ventas.csv -output /taller/output/promedio -mapper "bash mapper_promedio.sh" -reducer "bash reducer_promedio.sh"
```

**Consultar el resultado:**

```powershell
docker exec taller-namenode hdfs dfs -cat /taller/output/promedio/part-*
```

**Resultados esperados:**

| Categoría | Precio promedio |
|---|---:|
| encendido | $26.500 |
| filtros | $17.000 |
| frenos | $26.500 |
| lubricantes | $45.666,67 |
| transmision | $128.000 |

**Validación manual:**

Para la categoría filtros:

(26000 + 8000) / 2 = 17000

**Estado verificado en YARN:** SUCCEEDED.

---

### 9.3. Job 3: Top 3 de productos con mayores ingresos

**Objetivo:** identificar los tres productos que generan mayores ingresos según los datos de prueba.

El ingreso se calcula mediante:

Ingreso = cantidad × precio unitario

**Mapper:** `mapper_top3.sh`  
**Reducer:** `reducer_top3.sh`

**Comando de ejecución:**

```powershell
docker exec taller-namenode hadoop jar /opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar -D mapreduce.job.reduces=1 -files /jobs/mapper_top3.sh,/jobs/reducer_top3.sh -input /taller/input/ventas.csv -output /taller/output/top3 -mapper "bash mapper_top3.sh" -reducer "bash reducer_top3.sh"
```

**Consultar el resultado:**

```powershell
docker exec taller-namenode hdfs dfs -cat /taller/output/top3/part-*
```

**Resultados esperados:**

| Producto | Ingresos |
|---|---:|
| aceite | $182.000 |
| kit_arrastre | $128.000 |
| bujia | $103.000 |

**Estado verificado en YARN:** SUCCEEDED.

**Nota:** para volver a ejecutar cualquiera de estos trabajos se debe eliminar previamente su directorio de salida en HDFS, ya que Hadoop no sobrescribe automáticamente los resultados existentes.

---

## 10. Verificación de aplicaciones en YARN

Se utilizó el siguiente comando:

```powershell
docker exec taller-namenode yarn application -list -appStates ALL
```

Las tres aplicaciones quedaron registradas correctamente.

| Trabajo | Application ID | Estado final |
|---|---|---|
| WordCount | application_1794258864694_0001 | SUCCEEDED |
| Promedio | application_1794258864694_0002 | SUCCEEDED |
| Top 3 | application_1794258864694_0003 | SUCCEEDED |

Los tres trabajos alcanzaron el 100 % de progreso.

### Consulta de logs

Los logs se pueden consultar mediante el identificador de cada aplicación.

Ejemplo para WordCount:

```powershell
docker exec taller-namenode yarn logs -applicationId application_1794258864694_0001
```

Esta información permite revisar la ejecución y diagnosticar posibles errores.

---

## 11. Prueba de tolerancia a fallos

Para evaluar la tolerancia a fallos de HDFS se realizó una prueba controlada sobre el segundo DataNode.

### Verificar el estado inicial

```powershell
docker exec taller-namenode hdfs dfsadmin -report
```

```powershell
docker exec taller-namenode hdfs fsck /taller/input/ventas.csv -files -blocks -locations
```

### Detener el segundo DataNode

```powershell
docker compose stop datanode2
```

### Comprobar el acceso al archivo

```powershell
docker exec taller-namenode hdfs dfs -cat /taller/input/ventas.csv
```

### Revisar el estado de HDFS

```powershell
docker exec taller-namenode hdfs dfsadmin -report
```

```powershell
docker exec taller-namenode hdfs fsck /taller/input/ventas.csv -files -blocks -locations
```

### Recuperar el DataNode

```powershell
docker compose start datanode2
```

### Comprobar la recuperación

```powershell
docker exec taller-namenode hdfs dfsadmin -report
```

```powershell
docker exec taller-namenode hdfs fsck /taller/input/ventas.csv -files -blocks -locations
```

**Análisis:**

HDFS utiliza la replicación de bloques para reducir el riesgo de pérdida de información cuando un DataNode deja de estar disponible.

Si existe una copia funcional de los bloques en otro nodo, el sistema puede continuar permitiendo el acceso a los archivos.

Esta práctica permite observar el comportamiento del clúster durante la pérdida temporal de un nodo y su posterior recuperación.

Los resultados específicos de la prueba se documentan en el informe y las capturas de la carpeta `evidencias`.

---

## 12. Evidencias del proyecto

Las capturas de pantalla se encuentran organizadas en la carpeta:

`evidencias/`

Incluyen:

- Despliegue del clúster.
- Verificación del NameNode y los DataNodes.
- Carga de archivos en HDFS.
- Resultados de los tres trabajos MapReduce.
- Verificación de aplicaciones en YARN.
- Consulta de logs.
- Prueba de tolerancia a fallos.
- Recuperación del DataNode.

Para consultar la explicación detallada de las pruebas y sus resultados, revisar:

**[Informe del taller HDFS y MapReduce](INFORME_PARA_COMPLETAR.md)**

---

## 13. Detener el proyecto

Para detener el clúster sin eliminar sus volúmenes de datos:

```powershell
docker compose down
```

Para iniciarlo nuevamente:

```powershell
docker compose up -d
```

**Importante:** evitar utilizar `docker compose down -v`, ya que esta opción elimina los volúmenes de Docker y puede provocar la pérdida de los datos almacenados en HDFS.

---

## 14. Conclusión

Este proyecto permitió implementar un entorno local de procesamiento distribuido utilizando Docker y Hadoop.

Mediante HDFS fue posible almacenar archivos y trabajar con una arquitectura conformada por un NameNode y dos DataNodes.

Los tres trabajos MapReduce permitieron realizar diferentes operaciones sobre los datos almacenados y finalizaron satisfactoriamente en YARN.

También se exploraron herramientas de monitoreo y mecanismos de tolerancia a fallos que permiten comprender cómo funcionan los sistemas distribuidos.

En general, el taller ayudó a relacionar los conceptos teóricos de Big Data con actividades prácticas de configuración, almacenamiento, procesamiento y supervisión.

---

## 15. Referencias

- [Documentación oficial de Apache Hadoop](https://hadoop.apache.org/docs/)
- [Arquitectura de HDFS](https://hadoop.apache.org/docs/r3.2.1/hadoop-project-dist/hadoop-hdfs/HdfsDesign.html)
- [MapReduce Tutorial](https://hadoop.apache.org/docs/r3.2.1/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html)
- [Docker Compose](https://docs.docker.com/compose/)
- [Big Data Europe - Docker Hadoop](https://github.com/big-data-europe/docker-hadoop)

**Material académico:** Taller práctico de Exploración de HDFS y Hadoop MapReduce con Docker. Profesor Heberth Martínez.
