#!/bin/bash

echo "### Creando nuevo archivo de texto plano llamado mytext.txt ###"
echo "Hola Mundo" > mytext.txt

echo "### Contenido del archivo mytext.txt ###"
cat mytext.txt

echo "### Creando fichero backup ###"
mkdir -p backup

echo "### Moviendo el archivo mytext.txt al fichero backup ###"
mv mytext.txt backup/

echo "### Contenido del fichero backup ###"
ls -la backup

echo "### Eliminando el fichero mytext.txt del fichero backup ###"
rm backup/mytext.txt

echo "### Eliminando el fichero backup ###"
rmdir backup
