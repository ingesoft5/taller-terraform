#!/usr/bin/env bash
# ==============================================================================
# Script de Preparación Autónomo (Zero-Sudo) para Salas 205M y 206M
# Universidad Icesi — Ingeniería de Software V (2026-2)
# ==============================================================================

set -euo pipefail

TF_VERSION="1.9.8"
LOCAL_BIN="$HOME/.local/bin"
ZIP_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"

echo "========================================================================"
echo " [SETUP] Verificación de Entorno de Laboratorio: Salas 205M / 206M"
echo "========================================================================"

# 1. Verificar acceso a Docker
echo -n "[1/4] Verificando acceso a Docker Engine (socket local)... "
if docker info > /dev/null 2>&1; then
    echo "OK (Acceso disponible sin sudo)"
else
    echo "ERROR"
    echo "(!) No se tiene permiso de lectura/escritura sobre /var/run/docker.sock."
    echo "    Asegúrese de estar conectado con el usuario 'docker'."
    exit 1
fi

# 2. Verificar o instalar Terraform
echo -n "[2/4] Verificando instalación de Terraform... "
if command -v terraform &> /dev/null; then
    CURRENT_VER=$(terraform version | head -n 1)
    echo "OK ($CURRENT_VER detectado en PATH)"
else
    echo "NO ENCONTRADO"
    echo "      Instalando Terraform ${TF_VERSION} en ${LOCAL_BIN} (Modo Zero-Sudo)..."
    mkdir -p "${LOCAL_BIN}"
    TMP_ZIP="/tmp/terraform_${TF_VERSION}.zip"
    curl -sS -L "${ZIP_URL}" -o "${TMP_ZIP}"
    unzip -q -o "${TMP_ZIP}" -d "${LOCAL_BIN}/"
    chmod +x "${LOCAL_BIN}/terraform"
    rm -f "${TMP_ZIP}"
    
    # Agregar al PATH de la sesión actual
    export PATH="${LOCAL_BIN}:${PATH}"
    
    # Persistir en ~/.bashrc si no existe
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    echo "      Terraform instalado exitosamente en ${LOCAL_BIN}/terraform"
fi

# 3. Validar versión de Terraform
echo -n "[3/4] Validando binario de Terraform... "
TF_OUTPUT=$("${LOCAL_BIN}/terraform" version 2>/dev/null || terraform version)
echo "OK (${TF_OUTPUT%%$'\n'*})"

# 4. Pre-descarga de imágenes base para el taller (opcional y tolerante a fallos)
echo "[4/4] Verificando imágenes base para el laboratorio..."
for IMG in "nginx:alpine" "redis:7-alpine" "postgres:16-alpine"; do
    if docker image inspect "${IMG}" > /dev/null 2>&1; then
        echo "  - Imagen ${IMG}: Ya presente en caché local."
    else
        echo -n "  - Descargando ${IMG}... "
        docker pull -q "${IMG}" > /dev/null 2>&1 && echo "Listo" || echo "Pendiente (se descargará al aplicar Terraform)"
    fi
done

echo "========================================================================"
echo " [LISTO] Entorno configurado exitosamente para la práctica de Terraform."
echo " Si abrió una terminal nueva, ejecute: export PATH=\"\$HOME/.local/bin:\$PATH\""
echo "========================================================================"
