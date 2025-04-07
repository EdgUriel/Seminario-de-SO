@echo off
echo ### Creando nuevo archivo de texto plano llamado mytext.txt ###
echo Hola Mundo > mytext.txt
echo ### Imprimiendo contenido del archivo mytext.txt ###
type mytext.txt
echo ### Creando subdirectorio llamado backup ###
mkdir backup
echo ### Copiando archivo mytext.txt al subdirectorio backup ###
copy mytext.txt backup\
echo ### Listando el contenido del subdirectorio backup ###
dir backup
echo ### Eliminando el archivo mytext.txt del subdir backup ###
del backup\mytext.txt
echo ### Eliminando el subdirectorio backup ###
rmdir backup
pause