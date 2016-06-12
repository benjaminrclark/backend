#!/bin/bash

set -o nounset -o errexit -o pipefail -o errtrace

error() {
   local sourcefile=$1
   local lineno=$2
   echo "ERROR at ${sourcefile}:${lineno}; Last logs:"
   grep otto /var/log/syslog | tail -n 20
}
trap 'error "${BASH_SOURCE}" "${LINENO}"' ERR

oe() { "$@" 2>&1 | logger -t otto > /dev/null; }
ol() { echo "[otto] $@"; }

ol "Adding apt repositories and updating..."
sudo apt-get update
sudo apt-get install -y python-software-properties software-properties-common apt-transport-https
sudo apt-add-repository -y ppa:brightbox/ruby-ng
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main' | sudo tee /etc/apt/sources.list.d/passenger.list > /dev/null
sudo apt-get update

export RUBY_VERSION="2.2"
export ENVCONSUL_VERSION="0.6.1"

ol "Installing Ruby and other packages..."
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y git build-essential \
  libpq-dev zlib1g-dev software-properties-common \
  libpq-dev curl unzip net-tools netcat \
  ruby$RUBY_VERSION ruby$RUBY_VERSION-dev

ol "Downloading envconsul..."
sudo curl -L -o ./envconsul.zip https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip
sudo unzip ./envconsul.zip
sudo cp ./envconsul /usr/bin/
sudo chmod +x /usr/bin/envconsul

ol "Installing Bundler..."
sudo gem install bundler --no-ri --no-rdoc

ol "Installing Foreman..."
sudo gem install foreman --no-ri --no-rdoc

ol "Extracting app..."
sudo mkdir -p /srv/otto-app
sudo tar zxf /tmp/otto-app.tgz -C /srv/otto-app

ol "Adding application user..."
sudo adduser --disabled-password --gecos "" otto-app

ol "Setting permissions..."
sudo chown -R otto-app: /srv/otto-app

ol "Bundle installing the app..."
sudo -u otto-app -i /bin/bash -lc "cd /srv/otto-app && bundle install --deployment --without development ${APP_NAME}"

ol "...done!"
