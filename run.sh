#!/usr/bin/env bash

set -e

echo Installing docker-compose
os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)
pro=$(dpkg --print-architecture)
terraform_version="1.2.5"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.1.1/docker-compose-${os}-${arch}" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo Installing terraform onto machine...
mkdir -p "${HOME}/bin"
sudo apt-get update && sudo apt-get install -y unzip jq
pushd "${HOME}/bin"

wget -q "https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_${pro}.zip"
unzip -q -o "terraform_${terraform_version}_linux_${pro}.zip"
. "${HOME}/.profile"
popd
pushd /vagrant
docker build ./services/account -t form3tech-oss/platformtest-account
docker build ./services/gateway -t form3tech-oss/platformtest-gateway
docker build ./services/payment -t form3tech-oss/platformtest-payment
docker-compose up -d
# Added this sleep because sometime I've got an EOF 
# for terroform not be able to conenct to the vault
sleep 10
popd
echo Applying terraform script
pushd /vagrant/tf
terraform init -upgrade
terraform workspace new development
terraform apply -target=module.vault_dev -target=module.containers_dev -auto-approve
terraform workspace new staging
terraform apply -target=module.vault_stg -target=module.containers_stg -auto-approve
terraform workspace new production
terraform apply -target=module.vault_prod -target=module.containers_prod -auto-approve
popd
