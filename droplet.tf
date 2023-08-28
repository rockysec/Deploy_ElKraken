terraform {
    required_version = ">=1.4.0"     
    required_providers {
    digitalocean = {
    source  = "digitalocean/digitalocean"
    version = "~> 2.0"
}
}
}

# Es opcional, pero puedes agregar tags aca a tus recursos de digital ocean para mejor control, el default definido alcanza
resource "digitalocean_tag" "apps-node" {
name = "apps-node"
}

# Zona donde defines las caracteristicas del runner y recursos que deseas utilizar, el default definido alcanza
resource "digitalocean_droplet" "appnode" {
    image = "debian-11-x64"
    name = "runner-scan-1"
    region = "sfo3"
    size = "s-2vcpu-4gb"
    #size = "s-1vcpu-512mb-10gb"
    tags   = [digitalocean_tag.apps-node.id]
    ssh_keys = [
      var.ssh_fingerprint
    ]

#Aca se define la conexion SSH que realiza el action de Github hacia tu server en Digital Ocean para poder instalar las herramientas necesarias, el default definido alcanza
connection {
host = self.ipv4_address
user = "root"
type = "ssh"
private_key = file(var.pvt_key)
timeout = "2m"
}

#Aca se define se ejecutan los comandos necesarios para instalar las herramientas, el default definido alcanza pero si requieres algo adicional esta es la zona para aplicarlo
provisioner "remote-exec" {
inline = [
"export PATH=$PATH:/usr/bin",
# Instalacion de herramientas
"apt-get update",
"apt-get install git -y",
"apt-get install tmux -y",
"git clone https://github.com/rockysec/ElKraken-Tools",
"bash ElKraken-Tools/install.sh",
"touch ~/tools/ElKraken/domains.txt",
# aca modificas el dominio vulweb.com por el dominio que desees, si quieres concatenar mas de un dominio en el mismo escaneo, puedes agregarlo de la siguiente manera solo ten en cuenta que esto aumentara los tiempos del uso del runner y con ello los costos "echo dominio1.com >> ~/tools/ElKraken/domains.txt && "echo dominio2.com >> ~/tools/ElKraken/domains.txt ...." 
"echo vulweb.com >> ~/tools/ElKraken/domains.txt", 
"tmux new-session -d -s myscan bash ~/tools/customscripts/loop_scan.sh ~/tools/ElKraken/domains.txt"
]
}
}

output "droplet_ip_address" {
value = digitalocean_droplet.appnode.ipv4_address
}
