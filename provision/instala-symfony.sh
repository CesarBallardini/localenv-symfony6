#!/usr/bin/bash

SYMFONY_VERSION=4.26.11
URL_DOWNLOAD=https://github.com/symfony/cli/releases/download/v${SYMFONY_VERSION}/symfony_linux_amd64.gz

cd /vagrant/tmp/
[ -f symfony_linux_amd64.gz ] || wget ${URL_DOWNLOAD}
gunzip -c symfony_linux_amd64.gz | sudo tee /usr/local/bin/symfony >/dev/null
sudo chmod a+rx /usr/local/bin/symfony


