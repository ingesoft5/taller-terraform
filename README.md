# Taller Práctico de Infraestructura como Código (IaC) con Terraform
### On-Premise (Docker / Proxmox VE) y Cloud (AWS / LocalStack)

> **Universidad Icesi** · Facultad de Ingeniería y Ciencias Básicas  
> **Ingeniería de Software V** (Semestre 2026-2) · Semana 13 · Sesión 26  
> **Ambiente de Práctica**: Salas de Cómputo 205M y 206M (Ubuntu Linux x86_64 sin `sudo`)  
> 🌐 **Guía Interactiva Oficial**: [https://pi2tools.icesi.edu.co/iaslab/talleres-ingesoftV/docs/semana-13/taller-terraform/](https://pi2tools.icesi.edu.co/iaslab/talleres-ingesoftV/docs/semana-13/taller-terraform/)

---

## 🚀 Inicio Rápido en Salas 205M y 206M

Las estaciones de las salas 205M y 206M ejecutan Ubuntu Linux x86_64 con el usuario estándar `docker` sin privilegios de `sudo`.

### Paso 1: Clonar el repositorio
Abre una terminal en la sala y clona este repositorio público:
```bash
git clone https://github.com/ingesoft5/taller-terraform.git
cd taller-terraform
```

### Paso 2: Preparar el entorno (Modo Zero-Sudo)
Ejecuta el script autónomo de verificación e instalación de Terraform en tu espacio de usuario (`~/.local/bin`):
```bash
bash setup_sala_205m_206m.sh
```

El script verificará el acceso al daemon local de Docker e instalará Terraform en tu `$HOME/.local/bin/terraform` persistiendo la ruta en tu `~/.bashrc`.

### Paso 3: Validar Terraform
```bash
# Recargar variables de entorno si es necesario
source ~/.bashrc

# Verificar versión instalada
terraform version
```
Deberás ver: `Terraform v1.9.8 on linux_amd64`.

---

## 📂 Estructura del Taller

```text
taller-terraform/
├── 01_docker_local_stack/         # Laboratorio 1: Despliegue de Stack Local con Docker
│   ├── main.tf                    # Declaración de proveedores (kreuzwerker/docker) y recursos
│   ├── variables.tf               # Tipos estrictos (app_name, port_http) y validaciones
│   ├── terraform.tfvars           # Valores asignados para Sala 205M/206M
│   └── outputs.tf                 # URLs y endpoints para pruebas con curl
│
├── 02_proxmox_k8s_node/           # Laboratorio 2: Nodos Virtuales On-Premise (Proxmox VE)
│   ├── main.tf                    # Definición de VM clonada para worker node K8s
│   ├── variables.tf               # Parámetros de CPU, memoria RAM y bridge vmbr0
│   └── terraform.tfvars           # Configuración del hipervisor
│
├── 03_aws_emulated_localstack/    # Laboratorio 3: Infraestructura Cloud Emulada (AWS S3)
│   ├── main.tf                    # Provider AWS apuntando a endpoints locales de LocalStack
│   └── variables.tf               # Nombres de buckets y tags institucionales
│
├── setup_sala_205m_206m.sh        # Script autónomo de instalación Zero-Sudo
├── Taller_Terraform_IaC_IngesoftV.pdf # Guía completa en formato PDF
└── README.md                      # Instrucciones de la práctica
```

---

## 🛠️ Guía Rápida de los Laboratorios

### 🐳 Laboratorio 1: Stack Local con Docker

1. Entra a la carpeta del stack local:
   ```bash
   cd 01_docker_local_stack
   ```
2. Inicializa Terraform y descarga los plugins necesarios:
   ```bash
   terraform init
   ```
3. Genera y audita el plan de ejecución:
   ```bash
   terraform plan
   ```
4. Aplica el despliegue creando la red y el contenedor:
   ```bash
   terraform apply
   ```
   *(Escribe `yes` para confirmar)*
5. Verifica el servicio corriendo:
   ```bash
   terraform output
   curl http://localhost:8090
   ```

### 🧪 Reto: Detección y Auto-curación de Derivas (*Drift Detection*)
1. Elimina el contenedor por fuera de Terraform:
   ```bash
   docker rm -f icesi_nginx_sala_205m
   ```
2. Observa cómo Terraform detecta la discrepancia:
   ```bash
   terraform plan
   ```
3. Reconcilia la infraestructura sin alterar la red:
   ```bash
   terraform apply -auto-approve
   ```

### 🧹 Limpieza Controlada
Al finalizar tu sesión en la sala de cómputo, destruye los recursos creados:
```bash
terraform destroy -auto-approve
```

---

## 📖 Enlaces de Interés
* **Guía Interactiva con Reproductores Vectoriales**: [https://pi2tools.icesi.edu.co/iaslab/talleres-ingesoftV/docs/semana-13/taller-terraform/](https://pi2tools.icesi.edu.co/iaslab/talleres-ingesoftV/docs/semana-13/taller-terraform/)
* **Documentación Oficial de Terraform**: [https://developer.hashicorp.com/terraform/docs](https://developer.hashicorp.com/terraform/docs)
* **Proveedor kreuzwerker/docker**: [https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
