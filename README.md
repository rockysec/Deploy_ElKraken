# Automatizacion para el despliegue de servidores de escaneo
Esta herramienta permite desplegar de manera automatizada nodos de escaneo via terraform a la nube de digital occean.
Permite deplegar servidores con suficientes recursos para utilizar la herramienta "El Kraken" y analizar posibles vulnerabilidades presentes en algun dominio.
Esta herramienta ofrece rapidez de despliegue de servidores con herramientas preinstaladas en un periodo no mayor a 10 minutos. Luego de finalizar el scan, el servidor se puede destruir directamente desde la consola de digital ocean. Esto nos permitira optimizar costos de recursos, ya que los servidores se despliegan a necesidad y se borran posterior a su uso, ayudandonos con esto a no tener un servidor encendido de manera perpetua, lo cual nos llevaria a un costo aproximado de 50 dolares por mes con un servidor de las caracteristicas utilizadas en esta herramienta.

# Configuracion
1 - Antes que nada es necesario agregar en el archivo "provider.tf" el token correspondiente a la api de digital ocean tal como se muestra a continuacion
  
provider "digitalocean" {
  token = "dop_v1_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

2 - Como segundo paso es necesario completar el action con los secrets necesarios para ejecutar el pipeline:
En donde:
- DO_TOKEN corresponde al token de la api key de digital ocean en donde vas a desplegar el runner
- PUB_KEY Es la llave publica de tu certificado a utilizar para conectarte via ssh al runner
- PVT_KEY (opcional) Es la llave privada que utilizara tu servidor para enviar la informacion recopilada via ssh al repositorio y mantenerla respaldada
- SSH_RSA es el "know host" que necesitas tener aplicado en tu runner con el fin de que no te lo solicite cuando vayas a conectarte via ssh
  
<img width="1119" alt="image" src="https://github.com/rockysec/deploy_vps/assets/48323046/d9fcf61c-fb54-4c74-a23f-17b4825b3832">

# Modo de uso
Una vez configuradas las variables privadas necesarias solo debes trabajar con github CLI o WEB realizando cambios en el archivo "deploy_vps.tf", en este archivo puedes definir el tamaño de procesamiento del servidor a utilizar para el runner y los dominios a escanear. Una vez definas el dominio a escanear, realizas un commit y automaticamente se va desplegar el runner, se le van a instalar todas las herramientas necesarias para que El Kraken pueda funcionar y comenzara el escaneo.

Nota: El despligue del servidor no tomara mas de 10 minutos. El tiempo de escaneo al dominio el cual estaras evaluando las vulnerabilidades, va depender de lo grande que sea el mismo, mientras mas subdominios tenga que analizar, mas tiempo va demorar, pero el tiempo por cada analisis a cada subdominio es bastante rapido teniendo un promedio de un par de minutos por cada uno de ellos.

Espero sea de utilidad la herramienta y pueda facilitar tu proceso de bug bounty.

##Happy Hacking!
