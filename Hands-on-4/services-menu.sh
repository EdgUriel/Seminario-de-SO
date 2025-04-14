#!/bin/bash

while true; do
    clear
    echo "=============================="
    echo "    Menú de Servicios Linux   "
    echo "=============================="
    echo "1) Mostrar el contenido de un directorio"
    echo "2) Crear un archivo de texto"
    echo "3) Comparar dos archivos de texto"
    echo "4) Reemplazar palabras en un archivo (usando awk)"
    echo "5) Buscar un patrón en un archivo (usando grep)"
    echo "6) Salir"
    echo "------------------------------"
    read -p "Ingrese su opción: " opcion

    case $opcion in
        1)
            echo ">> Opción 1: Mostrar contenido de un directorio."
            read -p "Ingrese la ruta absoluta del directorio: " dir
            if [ -d "$dir" ]; then
                echo "Archivos dentro de $dir:"
                ls -lh "$dir"
            else
                echo "Error: El directorio no existe."
            fi
            read -p "Presione enter para continuar..."
            ;;
        2)
            echo ">> Opción 2: Crear un archivo de texto."
            read -p "Nombre del archivo (sin extensión): " nombre
            read -p "Texto que desea guardar en el archivo: " texto
            echo "$texto" > "${nombre}.txt"
            echo "Archivo '${nombre}.txt' creado correctamente."
            read -p "Presione enter para continuar..."
            ;;
        3)
            echo ">> Opción 3: Comparar dos archivos de texto."
            read -p "Ingrese la ruta del primer archivo: " file1
            read -p "Ingrese la ruta del segundo archivo: " file2
            if [ -f "$file1" ] && [ -f "$file2" ]; then
                echo "Comparando archivos..."
                diff "$file1" "$file2"
                status=$?
                if [ $status -eq 0 ]; then
                    echo "Los archivos son idénticos."
                elif [ $status -eq 1 ]; then
                    echo "Los archivos tienen diferencias (mostradas arriba)."
                else
                    echo "Ocurrió un error al comparar los archivos."
                fi
            else
                echo "Error: Uno o ambos archivos no se han hallado."
            fi
            read -p "Presione enter para continuar..."
            ;;
        4)
            echo ">> Opción 4: Reemplazar palabras en un archivo (awk)."
            read -p "Ingrese la ruta del archivo: " archivo
            if [ -f "$archivo" ]; then
                read -p "Palabra a buscar: " buscar
                read -p "Palabra nueva para reemplazarla: " reemplazo
                awk -v b="$buscar" -v r="$reemplazo" '{gsub(b, r); print}' "$archivo" > temp.txt && mv temp.txt "$archivo"
                echo "Reemplazo completado."
                echo "Contenido actualizado:"
                cat "$archivo"
            else
                echo "Error: El archivo no existe."
            fi
            read -p "Presione enter para continuar..."
            ;;
        5)
            echo ">> Opción 5: Buscar un patrón en un archivo (grep)."
            read -p "Ingrese la ruta del archivo: " archivo
            if [ -f "$archivo" ]; then
                read -p "Ingrese el texto o palabra a buscar: " patron
                echo "Resultados encontrados:"
                grep --color=auto "$patron" "$archivo" || echo "No se encontró coincidencia."
            else
                echo "Error: El archivo no existe."
            fi
            read -p "Presione enter para continuar..."
            ;;
        6)
            echo "Saliendo del menú. ¡Hasta luego!"
            exit 0
            ;;
        *)
            echo "Opción no válida. Intente nuevamente."
            read -p "Presione enter para continuar..."
            ;;
    esac
done
