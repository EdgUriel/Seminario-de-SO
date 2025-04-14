#!/bin/bash
# Script para automatizar la creación y configuración de una Máquina Virtual con VBoxManage
# Requiere 8 argumentos:
# 1. Nombre de la máquina virtual.
# 2. Tipo de sistema operativo (ej. "Ubuntu_64").
# 3. Número de CPUs.
# 4. Tamaño de memoria RAM en GB.
# 5. Tamaño de memoria VRAM en GB.
# 6. Tamaño de disco duro virtual en GB.
# 7. Nombre del controlador SATA.
# 8. Nombre del controlador IDE.

if [ "$#" -ne 8 ]; then
    echo "Uso: $0 <nombre_vm> <tipo_os> <num_cpus> <ram_en_GB> <vram_en_GB> <disco_en_GB> <nombre_SATA> <nombre_IDE>"
    exit 1
fi

VM_NAME=$1
OS_TYPE=$2
NUM_CPUS=$3
RAM_GB=$4
VRAM_GB=$5
DISK_GB=$6
SATA_NAME=$7
IDE_NAME=$8

# Conversión simple de GB a MB (suponiendo valores enteros)
RAM_MB=$(( RAM_GB * 1024 ))
VRAM_MB=$(( VRAM_GB * 1024 ))
DISK_MB=$(( DISK_GB * 1024 ))

# VirtualBox permite un máximo de 256 MB para VRAM.
if [ "$VRAM_MB" -gt 256 ]; then
    echo "Advertencia: El valor de VRAM solicitado ($VRAM_MB MB) excede el máximo permitido (256 MB)."
    echo "Se ajustará la VRAM a 256 MB."
    VRAM_MB=256
fi

echo "=============================================="
echo "   Creación y Configuración de la VM '$VM_NAME'   "
echo "=============================================="
echo "Parámetros recibidos:"
echo "  • Sistema Operativo:  $OS_TYPE"
echo "  • CPUs:               $NUM_CPUS"
echo "  • Memoria RAM:        ${RAM_GB} GB  (${RAM_MB} MB)"
echo "  • Memoria VRAM:       ${VRAM_GB} GB  (ajustada a ${VRAM_MB} MB)"
echo "  • Disco Duro Virtual: ${DISK_GB} GB  (${DISK_MB} MB)"
echo "  • Controlador SATA:   $SATA_NAME"
echo "  • Controlador IDE:    $IDE_NAME"
echo "----------------------------------------------"

# Asegúrate de que VBoxManage esté en el PATH.
# Si no, descomenta la siguiente línea y ajusta la ruta si es necesario:
export PATH="$PATH:/c/Program Files/Oracle/VirtualBox"

echo "Creando la máquina virtual..."
VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register
if [ $? -ne 0 ]; then
    echo "Error al crear la VM. Revise el comando VBoxManage y los parámetros."
    exit 1
fi

echo "Configurando CPUs, RAM y VRAM..."
VBoxManage modifyvm "$VM_NAME" --cpus "$NUM_CPUS" --memory "$RAM_MB" --vram "$VRAM_MB"
if [ $? -ne 0 ]; then
    echo "Error al modificar la configuración de la VM."
    exit 1
fi

DISK_PATH="./${VM_NAME}_disk.vdi"
echo "Creando disco duro virtual: $DISK_PATH"
VBoxManage createhd --filename "$DISK_PATH" --size "$DISK_MB" --format VDI
if [ $? -ne 0 ]; then
    echo "Error al crear el disco duro virtual."
    exit 1
fi

echo "Creando y asociando el controlador SATA '$SATA_NAME'..."
VBoxManage storagectl "$VM_NAME" --name "$SATA_NAME" --add sata --controller IntelAhci
VBoxManage storageattach "$VM_NAME" --storagectl "$SATA_NAME" --port 0 --device 0 --type hdd --medium "$DISK_PATH"
if [ $? -ne 0 ]; then
    echo "Error al asociar el disco duro al controlador SATA."
    exit 1
fi

echo "Creando y asociando el controlador IDE '$IDE_NAME'..."
VBoxManage storagectl "$VM_NAME" --name "$IDE_NAME" --add ide
VBoxManage storageattach "$VM_NAME" --storagectl "$IDE_NAME" --port 0 --device 0 --type dvddrive --medium emptydrive
if [ $? -ne 0 ]; then
    echo "Error al asociar el dispositivo DVD al controlador IDE."
    exit 1
fi

echo "=============================================="
echo "La máquina virtual '$VM_NAME' ha sido creada y configurada con éxito."
echo "A continuación, se muestra la configuración completa de la VM:"
echo "----------------------------------------------"
VBoxManage showvminfo "$VM_NAME"

exit 0
