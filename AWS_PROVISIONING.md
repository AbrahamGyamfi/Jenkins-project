# AWS EC2 Provisioning Guide for TaskFlow

## 📋 Overview

This guide will help you provision EC2 instances for:
1. **Jenkins Server** - CI/CD automation
2. **Application Server** - Docker containerized TaskFlow application

## 🔧 Prerequisites

### 1. AWS Account Setup
- Active AWS account
- AWS CLI installed and configured
- Appropriate IAM permissions to create EC2 instances, security groups, and key pairs

### 2. AWS CLI Configuration
```bash
# Install AWS CLI (if not installed)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS CLI
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter default region (e.g., eu-west-1)
# Enter default output format (json)
```

### 3. Verify AWS Setup
```bash
# Test AWS credentials
aws sts get-caller-identity

# List available regions
aws ec2 describe-regions --output table
```

## 🚀 Quick Start

### Option 1: Automated Provisioning (Recommended)

```bash
# Run the provisioning script
./provision-ec2.sh
```

The script will automatically:
- ✅ Create security groups with required ports
- ✅ Generate SSH key pair
- ✅ Launch Jenkins server (t3.medium)
- ✅ Launch Application server (t3.small)
- ✅ Install Docker on both instances
- ✅ Install and configure Jenkins
- ✅ Save instance details to `ec2-instances.txt`

### Option 2: Custom Configuration

```bash
# Set custom instance types and region
export AWS_REGION="us-west-2"
export INSTANCE_TYPE_JENKINS="t3.large"
export INSTANCE_TYPE_APP="t3.medium"
export KEY_NAME="my-custom-key"

# Run provisioning
./provision-ec2.sh
```

## 📝 After Provisioning

### 1. Wait for Initialization (2-3 minutes)
The user data scripts need time to:
- Install Docker
- Install Jenkins
- Configure services

### 2. Access Jenkins Server

```bash
# SSH to Jenkins server
ssh -i taskflow-key.pem ubuntu@<JENKINS_PUBLIC_IP>

# Get Jenkins initial admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Access Jenkins web interface
# Open: http://<JENKINS_PUBLIC_IP>:8080
```

### 3. Configure Jenkins

1. **Unlock Jenkins** with the initial admin password
2. **Install suggested plugins**
3. **Create admin user**
4. **Configure Jenkins URL**

### 4. Add Credentials to Jenkins

#### Docker Hub Credentials
```
Manage Jenkins → Credentials → System → Global credentials → Add Credentials
- Kind: Username with password
- Username: <your-dockerhub-username>
- Password: <your-dockerhub-password>
- ID: dockerhub-credentials
```

#### EC2 SSH Key
```
Manage Jenkins → Credentials → System → Global credentials → Add Credentials
- Kind: SSH Username with private key
- Username: ubuntu
- Private Key: paste contents of taskflow-key.pem
- ID: ec2-ssh-key
```

#### EC2 Host Variable
```
Manage Jenkins → Manage Nodes and Clouds → Configure System
- Add Environment Variable:
  - Name: EC2_HOST
  - Value: <APP_SERVER_PUBLIC_IP>
```

### 5. Create Jenkins Pipeline

1. **New Item → Pipeline**
2. **Name:** TaskFlow-CI-CD
3. **Pipeline Definition:** Pipeline script from SCM
4. **SCM:** Git
5. **Repository URL:** https://github.com/AbrahamGyamfi/Jenkins-project.git
6. **Branch:** */main
7. **Script Path:** Jenkinsfile
8. **Save**

### 6. Run First Build

Click "Build Now" to start the CI/CD pipeline!

## 🔒 Security Group Ports

The script automatically configures these ports:

| Port | Service | Protocol |
|------|---------|----------|
| 22 | SSH | TCP |
| 80 | HTTP (Frontend) | TCP |
| 5000 | Backend API | TCP |
| 8080 | Jenkins | TCP |

## 📊 Instance Specifications

### Jenkins Server
- **Type:** t3.medium (2 vCPU, 4 GB RAM)
- **Storage:** 8 GB SSD
- **OS:** Ubuntu 22.04 LTS
- **Pre-installed:**
  - Java 11
  - Jenkins (latest)
  - Docker & Docker Compose
  - Git

### Application Server
- **Type:** t3.small (2 vCPU, 2 GB RAM)
- **Storage:** 8 GB SSD
- **OS:** Ubuntu 22.04 LTS
- **Pre-installed:**
  - Docker & Docker Compose
  - Git

## 🚀 Manual Deployment

If you want to deploy without Jenkins:

```bash
# Set your application server IP
export APP_SERVER=<your-app-server-ip>

# Run deployment script
./deploy.sh
```

## 🧹 Clean Up Resources

To terminate instances and clean up:

```bash
# Get instance IDs from ec2-instances.txt
# Or list instances:
aws ec2 describe-instances \
    --filters "Name=tag:Project,Values=TaskFlow" \
    --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name]' \
    --output table

# Terminate instances
aws ec2 terminate-instances --instance-ids <jenkins-id> <app-id>

# Delete security group (after instances are terminated)
aws ec2 delete-security-group --group-name taskflow-sg

# Delete key pair
aws ec2 delete-key-pair --key-name taskflow-key
rm -f taskflow-key.pem
```

## 🐛 Troubleshooting

### Can't SSH to instances
```bash
# Check security group allows your IP
# Check instance is running
aws ec2 describe-instances --instance-ids <instance-id>

# Verify key file permissions
chmod 400 taskflow-key.pem
```

### Jenkins not accessible on port 8080
```bash
# SSH to Jenkins server
ssh -i taskflow-key.pem ubuntu@<jenkins-ip>

# Check Jenkins status
sudo systemctl status jenkins

# Check Jenkins logs
sudo journalctl -u jenkins -f
```

### Docker containers not starting
```bash
# SSH to app server
ssh -i taskflow-key.pem ubuntu@<app-ip>

# Check Docker status
sudo systemctl status docker

# View container logs
docker-compose logs
```

## 💰 Cost Estimation

Approximate monthly costs (us-east-1):
- **Jenkins Server (t3.medium):** ~$30/month
- **Application Server (t3.small):** ~$15/month
- **Total:** ~$45/month

> **Tip:** Use AWS Free Tier eligible instance types (t2.micro) for testing to reduce costs.

## 📚 Additional Resources

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [JENKINS_SETUP.md](./JENKINS_SETUP.md) - Detailed Jenkins configuration

## ⚠️ Important Notes

1. **Security:** The security groups allow traffic from `0.0.0.0/0`. For production, restrict to your IP ranges.
2. **SSH Keys:** Keep `taskflow-key.pem` secure and never commit to git.
3. **Costs:** Remember to terminate instances when not in use to avoid charges.
4. **Updates:** Regularly update your EC2 instances for security patches.

## ✅ Next Steps

After provisioning:
1. ✅ Configure Jenkins with credentials
2. ✅ Create Jenkins pipeline job
3. ✅ Run first build
4. ✅ Access your application at `http://<APP_SERVER_IP>`
5. ✅ Monitor Jenkins builds and deployments

Happy deploying! 🚀
