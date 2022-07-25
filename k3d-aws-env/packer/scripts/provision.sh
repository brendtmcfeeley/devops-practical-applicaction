#!/usr/bin/bash

set -x
set -e

#
# Logic
#

# update and upgrade
sudo apt-get -y clean
sudo apt-get -y update
sudo apt-get -y upgrade

# install docker
curl -fsSL https://get.docker.com | sudo sh
sudo systemctl enable docker
docker --version

# install k3d
curl -fsSL https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
k3d --version

# obtain k3d / k3s constants
k3d_images_dir="$HOME/k3d_images"
k3s_version=$(k3d version | grep -oP '(?<=k3s version ).*(?= \(default\))')
k3s_airgap_tar_url="https://github.com/k3s-io/k3s/releases/download/$(echo $k3s_version | sed 's/-/+/g')/k3s-airgap-images-amd64.tar"

# install kubectl
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl > /dev/null
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
kubectl version --client

# install flux
curl -fsSL https://toolkit.fluxcd.io/install.sh | sudo bash
flux completion bash | sudo tee -a /etc/bash_completion.d/flux > /dev/null
flux --version

# install helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo bash
helm completion bash | sudo tee -a /etc/bash_completion.d/helm > /dev/null
helm version

# install other packages
sudo apt-get install -y jq
sudo snap install yq

# allow non root docker usage
sudo usermod -a -G docker $(whoami)

# needed for elasticsearch / associated containers
sudo sh -c "echo vm.max_map_count=262144 >> /etc/sysctl.conf"
sudo sysctl -p

# make sure sysctl is loaded in docker
sudo systemctl restart docker

# add k3s release tar to k3d agent images directory
mkdir -p $k3d_images_dir
curl -L $k3s_airgap_tar_url -o $k3d_images_dir/k3s-$k3s_version.tar

# create an initial cluster to download required docker images
# this saves time on deployment of k3d after instance deployment
# also, simulate the docker group since we can't easily reload groups
sg docker -c "k3d cluster create"

# import the k3s release container image into the initial cluster
# this will pre pull the k3d tools containers for future deployment use as well
# also, simulate the docker group since we can't easily reload groups
sg docker -c "docker save docker.io/rancher/k3s:$k3s_version > k3s.tar"
sg docker -c "k3d image import k3s.tar"
rm -rf k3s.tar

# delete that cluster and allow it to be provisioned after deployment
# also, the simulate docker group since we can't easily reload groups
sg docker -c "k3d cluster delete --all"

# update and upgrade again
sudo apt-get -y update
sudo apt-get -y upgrade

# reboot
sudo reboot