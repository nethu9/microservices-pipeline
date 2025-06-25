#!/bin/bash

set -e

echo "[Step 1] Updating system..."
sudo dnf update -y

echo "[Step 2] Installing containerd..."
sudo dnf install -y containerd

echo "[Step 3] Configuring containerd..."
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Set the cgroup driver to systemd
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl enable --now containerd

echo "[Step 4] Loading required kernel modules..."
sudo modprobe overlay
sudo modprobe br_netfilter

echo "[Step 5] Configuring sysctl params..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

echo "[Step 6] Disabling swap..."
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

echo "[Step 7] Adding Kubernetes repo..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

echo "[Step 8] Installing Kubernetes components..."
sudo dnf install -y kubelet kubeadm kubectl
sudo systemctl enable --now kubelet

#echo "[Step 9] Initializing Kubernetes cluster..."
#sudo kubeadm init --pod-network-cidr=192.168.0.0/16

#echo "[Step 10] Setting up kubectl for the current user..."
#mkdir -p $HOME/.kube
#sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

#echo "[Step 11] Installing Calico CNI plugin..."
#kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "✅ Kubernetes cluster setup is complete!"


#chmod +x install-k8s.sh
#./install-k8s.sh
