#!/bin/bash
set -e

# Update system
yum update -y                                     

# Disable swap
swapoff -a                                       
sed -i '/ swap / s/^/#/' /etc/fstab               
# Load kernel modules
echo -e "overlay\nbr_netfilter" > /etc/modules-load.d/k8s.conf   
modprobe overlay                                    
modprobe br_netfilter                               

# Sysctl network settings
cat <<EOF | tee /etc/sysctl.d/k8s.conf              
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system                                     

# Install container runtime (containerd)
yum install -y yum-utils device-mapper-persistent-data lvm2      
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo  
yum install -y containerd                        

# Configure containerd
containerd config default | tee /etc/containerd/config.toml      
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml     
systemctl enable --now containerd                   

# Add Kubernetes repo
cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo    
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
EOF

# Install Kubernetes components
yum install -y kubelet kubeadm kubectl            
systemctl enable --now kubelet                      

# Done
echo "Worker setup complete. Run the join command from master node."
