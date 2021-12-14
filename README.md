# README - local dev environment - symfony

Entorno Symfony 6.x con PHP 8.0 y MariaDB 10.3 sobre Ubuntu 20.04.


## Crear la VM:

```bash
git clone https://github.com/CesarBallardini/localenv-symfony6
cd localenv-symfony6/

# Instalar módulos requeridos para los roles Ansible
mkdir provision/ansible/roles/ tmp/
ansible-galaxy install -r requirements.yml --roles-path=provision/ansible/roles/

##
# levantar la VM

cp Vagrantfile.virtualbox Vagrantfile ; time vagrant up      # usa Virtualbox como provider

# o bien
cp Vagrantfile.docker Vagrantfile ;  time vagrant up  # usa Docker como provider, ej. en una Apple MAC con procesador M1

```

Apuntar el navegador del host a:

* http://192.168.56.10/
* http://sym6dev.virtual.ballardini.com.ar/phpmyadmin

* credenciales MariaDB y PHPMyAdmin:   `root / root123`


Dispone de PHP 8.0, Composer, Apache2, MariaDB.

Puede ahora crear su aplicación Symfony, armar el virtualhost de Apache y verla en el navegador de su PC.



# Apéndice A: requisitos

Entre paréntesis se indica la versión con la que fueron probados).

* Git (2.25.1)

* Virtualbox (6.1.30r148432)

* Vagrant (2.2.19)

* Plugins de Vagrant:
  * `vagrant-cachier` (1.2.1, global)
  * `vagrant-disksize` (0.1.3, global)
  * `vagrant-hostmanager` (1.8.9, global)
  * `vagrant-mutate` (1.2.0, global)
  * `vagrant-proxyconf` (2.0.10, global) (si tu salida a internet es a través de un proxy corporativo)
  * `vagrant-rekey-ssh` (0.1.9, global)
  * `vagrant-reload` (0.0.1, global)
  * `vagrant-share` (2.0.0, global)
  * `vagrant-vbguest` (0.30.0, global)

* Ansible (2.11.5)

# Apéndice B: crear la aplicación Blog Demo 2.0

```bash
composer create-project symfony/symfony-demo
cd symfony-demo/

# corre tests:
./bin/phpunit

# servidor de desarrollo
symfony serve --no-tls
```

Ahora puede acceder con el navegador de su pc a la URL de la aplicación: http://localhost:8000/

La demo usa SQLite como base de datos, que reside en `data/`.
Los logs de la aplicación se encuentran en `var/log/`, tanto para los ambientes `dev` como para `test`.
La configuración se hace mediante archivos de ambiente: `.env` para el entorno `dev` y `.env.test` para correr los tests.



