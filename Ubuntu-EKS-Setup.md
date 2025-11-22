<img width="1107" height="626" alt="image" src="https://github.com/user-attachments/assets/db18e7e9-8bc1-4309-9949-e484f6fec1fd" />

## Step - 1 : Create EKS Management Host in AWS ##

1) Launch new Ubuntu VM using AWS Ec2 ( t2.micro )	  
2) Connect to VM machine (e.g Mobaxterm, gitbash)

3) Install AWS CLI
```
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

4) Install eksctl
```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version
```

5) Install kubectl
```
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client
```

## Step - 2 : Create IAM role & attach to EKS Management Host ##

1) Create New Role using IAM service ( Select Usecase - ec2 ) 	
2) Add below permissions for the role <br/>
	- Administrator - acces <br/>
3) Enter Role Name (eksroleec2) 
4) Attach created role to EKS Management Host (Select EC2 => Click on Security => Modify IAM Role => attach IAM role we have created) 

<br/>

**Alternative Method :**  Create an IAM User 
1) Open AWS Console => IAM => Users => Create User
2) Enter a username, for example: eks-admin-user
3) Add Permissions:
    - Attach existing directly → AdministratorAccess
Complete the creation and download the Access Key & Secret Key
4) Generate Access Key & Secret Key (Select user => Security Credentials => Create access Key => CLI => next => Create access Key) 

After logging into your EC2 instance:
Run AWS configure:
```
aws configure
```
Enter:
- AWS Access Key ID
- AWS Secret Access Key
- Default region
- Default output format

## Step - 3 : Create EKS Cluster using eksctl ## 
**Syntax:** 

eksctl create cluster --name cluster-name  \
--region region-name \
--node-type instance-type \
--nodes-min 2 \
--nodes-max 2 \ 
--zones <AZ-1>,<AZ-2>

## N. Virgina: <br/>
```
eksctl create cluster --name my-cluster --region us-east-1 --node-type t2.medium  --zones us-east-1a,us-east-1b
```
## Mumbai: <br/>
```
eksctl create cluster --name my-cluster --region ap-south-1 --node-type t2.medium  --zones ap-south-1a,ap-south-1b
```

## Note: Cluster creation will take 5 to 10 mins of time (we have to wait). After cluster created we can check nodes using below command.

```
 kubectl get nodes  
```

### Note: We should be able to see EKS cluster nodes here. ##

### We are done with our Setup ###
	
## Step - 4 : After your practise, delete Cluster and other resources we have used in AWS Cloud to avoid billing ##

```
eksctl delete cluster --name my-cluster --region ap-south-1
```
