# Jenkins CI/CD Pipeline Setup Guide

## 📋 Overview

This document provides complete instructions for setting up the Jenkins CI/CD pipeline for TaskFlow application.

---

## 🔧 Prerequisites

### 1. Jenkins Server
- Jenkins 2.400+ installed
- Java 11 or later
- Docker installed on Jenkins agent
- Minimum 4GB RAM, 2 CPU cores

### 2. EC2 Instance (Deployment Target)
- Amazon EC2 instance running
- Docker and Docker Compose installed
- Security group allows inbound traffic on ports 22 (SSH), 80, and 5000
- SSH key pair created

### 3. Docker Registry
- Docker Hub account OR AWS ECR repository
- Registry credentials ready

---

## 🔌 Required Jenkins Plugins

Install the following plugins via **Manage Jenkins → Plugin Manager**:

1. **Pipeline** (core pipeline support)
2. **Git Plugin** (Git integration)
3. **Docker Pipeline** (Docker commands in pipeline)
4. **SSH Agent** (SSH credentials for EC2 deployment)
5. **Credentials Binding** (secure credential management)
6. **HTML Publisher** (for coverage reports)
7. **JUnit** (test result publishing)
8. **Blue Ocean** (optional, modern UI)
9. **Timestamper** (timestamps in logs)

### Installation Steps:
```
1. Go to Manage Jenkins → Manage Plugins
2. Click "Available" tab
3. Search for each plugin
4. Check the box next to each plugin
5. Click "Install without restart"
6. Wait for installation to complete
```

---

## 🔐 Configure Jenkins Credentials

### 1. Docker Registry Credentials (`registry_creds`)

**For Docker Hub:**
```
1. Go to Manage Jenkins → Manage Credentials
2. Click (global) domain
3. Click "Add Credentials"
4. Kind: Username with password
5. Scope: Global
6. Username: <your-dockerhub-username>
7. Password: <your-dockerhub-token>
8. ID: registry_creds
9. Description: Docker Hub Registry Credentials
10. Click "OK"
```

**For AWS ECR:**
```
1. Create IAM user with ECR permissions (AmazonEC2ContainerRegistryFullAccess)
2. Generate access key and secret key
3. In Jenkins, Add Credentials:
   - Kind: Username with password
   - Username: AWS
   - Password: <ECR token from aws ecr get-login-password>
   - ID: registry_creds
   
Note: For ECR, you may need to use AWS CLI credentials plugin
```

### 2. EC2 SSH Credentials (`ec2_ssh`)

```
1. Go to Manage Jenkins → Manage Credentials
2. Click "Add Credentials"
3. Kind: SSH Username with private key
4. Scope: Global
5. ID: ec2_ssh
6. Description: EC2 SSH Key
7. Username: ec2-user (or ubuntu for Ubuntu instances)
8. Private Key: Enter directly or from file
   - Paste your EC2 private key (.pem file contents)
9. Passphrase: (if your key has one)
10. Click "OK"
```

### 3. Git Credentials (Optional - `git_credentials`)

Only needed for private repositories:
```
1. Add Credentials
2. Kind: Username with password
3. Username: <github-username>
4. Password: <personal-access-token>
5. ID: git_credentials
6. Description: GitHub Access Token
```

---

## 📝 Configure Jenkinsfile

Update the environment variables in `Jenkinsfile`:

```groovy
environment {
    // Docker registry - Choose one:
    // For Docker Hub:
    REGISTRY_URL = "docker.io/your-username"
    
    // For AWS ECR:
    // REGISTRY_URL = "123456789012.dkr.ecr.us-east-1.amazonaws.com"
    
    // EC2 configuration
    EC2_HOST = "ec2-user@ec2-XX-XXX-XXX-XXX.compute-1.amazonaws.com"
    DEPLOY_PATH = "/home/ec2-user/taskflow"
}
```

---

## 🚀 Create Jenkins Pipeline Job

### Step 1: Create New Item
```
1. Click "New Item" in Jenkins dashboard
2. Enter name: TaskFlow-Pipeline
3. Select "Pipeline"
4. Click "OK"
```

### Step 2: Configure Pipeline
```
1. Description: "CI/CD Pipeline for TaskFlow Application"
2. Scroll to "Pipeline" section
3. Definition: Pipeline script from SCM
4. SCM: Git
5. Repository URL: <your-git-repo-url>
6. Credentials: Select git_credentials (if private repo)
7. Branch Specifier: */main
8. Script Path: Jenkinsfile
9. Click "Save"
```

### Step 3: Configure Build Triggers (Optional)
```
- Poll SCM: H/5 * * * * (check every 5 minutes)
- GitHub hook trigger (for push events)
```

---

## 🖥️ EC2 Instance Setup

### 1. Connect to EC2 Instance
```bash
ssh -i your-key.pem ec2-user@your-ec2-public-dns
```

### 2. Install Docker
```bash
# Update packages
sudo yum update -y

# Install Docker
sudo yum install docker -y

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ec2-user to docker group
sudo usermod -a -G docker ec2-user

# Verify installation
docker --version
```

### 3. Install Docker Compose
```bash
# Download Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

### 4. Configure Security Group
Ensure the following ports are open:
- **Port 22**: SSH access
- **Port 80**: HTTP (optional)
- **Port 5000**: Application access

### 5. Create Deployment Directory
```bash
mkdir -p /home/ec2-user/taskflow
```

### 6. Test SSH Connection from Jenkins
From Jenkins server:
```bash
ssh -i /path/to/key.pem ec2-user@your-ec2-dns
```

---

## 🧪 Update package.json for CI Testing

Add test results output to `package.json`:

```json
{
  "scripts": {
    "test": "jest --coverage --ci --testResultsProcessor=jest-junit"
  },
  "jest-junit": {
    "outputDirectory": "test-results",
    "outputName": "junit.xml"
  }
}
```

Install jest-junit:
```bash
npm install --save-dev jest-junit
```

---

## 🎯 Running the Pipeline

### First Run: Manual Trigger
```
1. Open TaskFlow-Pipeline job
2. Click "Build Now"
3. Watch build progress in console output
4. Monitor each stage in Blue Ocean (optional)
```

### Stages Overview:
1. **Checkout**: Clone repository
2. **Install Dependencies**: npm install for backend and frontend
3. **Build**: Build React frontend
4. **Test**: Run Jest tests with coverage
5. **Docker Build**: Create Docker image
6. **Docker Test**: Test container locally
7. **Push to Registry**: Push image to Docker Hub/ECR
8. **Deploy to EC2**: SSH deploy to production
9. **Cleanup**: Remove local images

---

## 🔍 Verification Steps

### 1. Check Pipeline Execution
- All stages should show green checkmarks
- Build time should be 5-10 minutes (first run may be longer)

### 2. Verify Docker Image
```bash
# On Jenkins server
docker images | grep taskflow-app

# Should show: taskflow-app with build number tag
```

### 3. Verify Registry Push
**Docker Hub:**
```
Visit: https://hub.docker.com/r/your-username/taskflow-app
```

**AWS ECR:**
```bash
aws ecr describe-images --repository-name taskflow-app
```

### 4. Verify EC2 Deployment
```bash
# SSH to EC2
ssh -i your-key.pem ec2-user@your-ec2-dns

# Check running containers
docker ps | grep taskflow

# Check application health
curl http://localhost:5000/health

# Check logs
docker logs taskflow-production
```

### 5. Access Application
```
http://your-ec2-public-dns:5000
```

---

## 📊 Viewing Build Artifacts

### Test Results
```
1. Open build in Jenkins
2. Click "Test Results"
3. View passed/failed tests
```

### Coverage Report
```
1. Open build in Jenkins
2. Click "Code Coverage Report"
3. View line/branch coverage
```

### Console Output
```
1. Open build in Jenkins
2. Click "Console Output"
3. View detailed logs
```

---

## 🐛 Troubleshooting

### Issue: Docker permission denied
```bash
# On Jenkins agent
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue: SSH connection refused
```bash
# Check EC2 security group allows port 22 from Jenkins IP
# Verify SSH key is correct in Jenkins credentials
# Test connection manually from Jenkins server
```

### Issue: Docker push authentication failed
```bash
# Verify registry credentials in Jenkins
# For Docker Hub: Use access token, not password
# For ECR: Ensure IAM user has correct permissions
```

### Issue: Tests failing in pipeline
```bash
# Run tests locally first: npm test
# Check Node.js version compatibility
# Ensure all dependencies are installed
```

### Issue: EC2 deployment fails
```bash
# SSH to EC2 and check Docker is running
sudo systemctl status docker

# Check available disk space
df -h

# Manually pull image to test registry access
docker pull your-registry/taskflow-app:latest
```

---

## 🔒 Security Best Practices

1. **Use SSH keys, not passwords** for EC2 access
2. **Rotate credentials regularly** (Docker, SSH keys)
3. **Use Docker Hub access tokens**, not passwords
4. **Enable HTTPS** for production (use nginx reverse proxy)
5. **Implement secrets management** (HashiCorp Vault, AWS Secrets Manager)
6. **Run containers as non-root user** (already in Dockerfile)
7. **Scan Docker images** for vulnerabilities (Trivy, Clair)
8. **Limit Jenkins credential scope** to specific jobs
9. **Use VPC and private subnets** for EC2 instances
10. **Enable Docker Content Trust** for image signing

---

## 📈 Monitoring

### Jenkins Monitoring
- Build history and trends
- Build time tracking
- Failed builds alerts

### Application Monitoring
```bash
# Check container health
docker ps
docker stats

# View application logs
docker logs -f taskflow-production

# Monitor system resources
top
df -h
```

### Health Check Endpoint
```bash
curl http://your-ec2-dns:5000/health
```

Response:
```json
{
  "status": "healthy",
  "timestamp": "2026-02-15T10:30:00.000Z",
  "tasksCount": 5
}
```

---

## 🔄 Pipeline Maintenance

### Update Pipeline
```
1. Modify Jenkinsfile in repository
2. Commit and push changes
3. Next build will use updated Jenkinsfile
```

### Rollback Deployment
```bash
# SSH to EC2
cd /home/ec2-user/taskflow

# Set previous image tag
export IMAGE_TAG=<previous-build-number>
docker-compose down
docker-compose up -d
```

### Clean Old Images on EC2
```bash
# SSH to EC2
docker system prune -a
```

---

## 📞 Support & Resources

### Jenkins Documentation
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)

### Docker Documentation
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

### AWS Documentation
- [EC2 User Guide](https://docs.aws.amazon.com/ec2/)
- [ECR User Guide](https://docs.aws.amazon.com/ecr/)

---

**Setup Completed**: Follow these steps to establish a complete CI/CD pipeline with Jenkins, Docker, and EC2 deployment.

**Last Updated**: February 15, 2026
