# Kind Kubernetes Cluster Setup

Set up a local multi-node Kubernetes cluster using **Kind** (Kubernetes in Docker).

> Kind docs: https://kind.sigs.k8s.io/docs/user/quick-start/

---

## Repository Files

| File | Purpose |
|------|---------|
| `install-ubuntu.sh` | Installs Docker, kubectl and Kind on Ubuntu / Debian |
| `install-amazon-linux.sh` | Installs Docker, kubectl and Kind on Amazon Linux / RHEL / CentOS |
| `kind-config.yaml` | Cluster config: 1 control-plane + 3 workers |

---

## 1. Run the Install Script

**Ubuntu / Debian**

```bash
chmod +x install-ubuntu.sh
./install-ubuntu.sh
```

**Amazon Linux / RHEL / CentOS**

```bash
chmod +x install-amazon-linux.sh
sudo ./install-amazon-linux.sh
```

---

## 2. Run Docker Without sudo

```bash
sudo usermod -aG docker $USER
newgrp docker        # or log out and log back in
docker ps
```

---

## 3. Create the Cluster

```bash
# Default cluster (single node, name: "kind")
kind create cluster

# Cluster with a custom name
kind create cluster --name=my-cluster

# Multi-node cluster using the config file
kind create cluster --config=kind-config.yaml --name=my-cluster
```

---

## 4. Verify the Cluster

```bash
kubectl cluster-info --context=kind-my-cluster
kind get clusters
kubectl get nodes
kubectl get pods -A
```


---

## 5. Delete the Cluster

```bash
kind delete cluster --name=kind-my-cluster
```

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `permission denied ... docker.sock` | Add user to docker group (see step 2) |
| `Cannot connect to the Docker daemon` | `sudo systemctl start docker` |
| Nodes stuck in `NotReady` | Wait 1–2 minutes, then check `kubectl get pods -n kube-system` |
| Image pull errors on create | Use a `kindest/node` tag supported by your Kind version |
