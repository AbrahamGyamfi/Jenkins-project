#!/bin/bash

# EC2 Instance Provisioning Script for TaskFlow Application
# This script provisions two EC2 instances: Jenkins Server and Application Server

set -e

echo "🚀 TaskFlow EC2 Instance Provisioning Script"
echo "=============================================="

# Configuration Variables
AWS_REGION="${AWS_REGION:-us-east-1}"
INSTANCE_TYPE_JENKINS="${INSTANCE_TYPE_JENKINS:-t3.medium}"
INSTANCE_TYPE_APP="${INSTANCE_TYPE_APP:-t3.small}"
AMI_ID="${AMI_ID:-ami-0c55b159cbfafe1f0}"  # Ubuntu 22.04 LTS - Update based on region
KEY_NAME="${KEY_NAME:-taskflow-key}"
SECURITY_GROUP_NAME="taskflow-sg"

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo "❌ AWS CLI not found. Please install it first."
    exit 1
fi

echo "✅ AWS CLI found"

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo "❌ AWS credentials not configured. Run 'aws configure' first."
    exit 1
fi

echo "✅ AWS credentials configured"

# Create Security Group
echo ""
echo "📋 Creating Security Group: $SECURITY_GROUP_NAME"
SG_ID=$(aws ec2 create-security-group \
    --group-name "$SECURITY_GROUP_NAME" \
    --description "Security group for TaskFlow application" \
    --region "$AWS_REGION" \
    --output text --query 'GroupId' 2>/dev/null || \
    aws ec2 describe-security-groups \
    --group-names "$SECURITY_GROUP_NAME" \
    --region "$AWS_REGION" \
    --output text --query 'SecurityGroups[0].GroupId')

echo "✅ Security Group ID: $SG_ID"

# Add Security Group Rules
echo ""
echo "🔒 Configuring Security Group Rules..."

# SSH access
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 \
    --region "$AWS_REGION" 2>/dev/null || echo "SSH rule already exists"

# HTTP access
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region "$AWS_REGION" 2>/dev/null || echo "HTTP rule already exists"

# Jenkins port
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0 \
    --region "$AWS_REGION" 2>/dev/null || echo "Jenkins rule already exists"

# Backend API port
aws ec2 authorize-security-group-ingress \
    --group-id "$SG_ID" \
    --protocol tcp \
    --port 5000 \
    --cidr 0.0.0.0/0 \
    --region "$AWS_REGION" 2>/dev/null || echo "Backend API rule already exists"

echo "✅ Security Group configured"

# Create Key Pair if not exists
echo ""
echo "🔑 Checking SSH Key Pair: $KEY_NAME"
if ! aws ec2 describe-key-pairs --key-names "$KEY_NAME" --region "$AWS_REGION" &>/dev/null; then
    echo "Creating new key pair..."
    aws ec2 create-key-pair \
        --key-name "$KEY_NAME" \
        --region "$AWS_REGION" \
        --query 'KeyMaterial' \
        --output text > "${KEY_NAME}.pem"
    chmod 400 "${KEY_NAME}.pem"
    echo "✅ Key pair created and saved to ${KEY_NAME}.pem"
else
    echo "✅ Key pair already exists"
fi

# User Data Script for Jenkins Server
cat > jenkins-userdata.sh <<'EOF'
#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install Java
apt-get install -y openjdk-11-jdk

# Install Docker
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Install Jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install -y jenkins

# Add jenkins user to docker group
usermod -aG docker jenkins

# Start Jenkins
systemctl start jenkins
systemctl enable jenkins

# Install additional tools
apt-get install -y git curl wget unzip

echo "Jenkins installation completed!"
EOF

# User Data Script for Application Server
cat > app-userdata.sh <<'EOF'
#!/bin/bash
set -e

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add ubuntu user to docker group
usermod -aG docker ubuntu

# Start Docker
systemctl start docker
systemctl enable docker

# Install additional tools
apt-get install -y git curl wget

echo "Application server setup completed!"
EOF

# Launch Jenkins EC2 Instance
echo ""
echo "🚀 Launching Jenkins Server Instance..."
JENKINS_INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE_JENKINS" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --user-data file://jenkins-userdata.sh \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=TaskFlow-Jenkins-Server},{Key=Project,Value=TaskFlow},{Key=Environment,Value=Production}]" \
    --region "$AWS_REGION" \
    --output text --query 'Instances[0].InstanceId')

echo "✅ Jenkins Instance ID: $JENKINS_INSTANCE_ID"

# Launch Application EC2 Instance
echo ""
echo "🚀 Launching Application Server Instance..."
APP_INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type "$INSTANCE_TYPE_APP" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --user-data file://app-userdata.sh \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=TaskFlow-App-Server},{Key=Project,Value=TaskFlow},{Key=Environment,Value=Production}]" \
    --region "$AWS_REGION" \
    --output text --query 'Instances[0].InstanceId')

echo "✅ Application Instance ID: $APP_INSTANCE_ID"

# Wait for instances to be running
echo ""
echo "⏳ Waiting for instances to be running..."
aws ec2 wait instance-running \
    --instance-ids "$JENKINS_INSTANCE_ID" "$APP_INSTANCE_ID" \
    --region "$AWS_REGION"

echo "✅ Instances are running!"

# Get instance details
echo ""
echo "📋 Retrieving Instance Details..."
JENKINS_PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$JENKINS_INSTANCE_ID" \
    --region "$AWS_REGION" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

APP_PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$APP_INSTANCE_ID" \
    --region "$AWS_REGION" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

# Save instance information
cat > ec2-instances.txt <<EOL
TaskFlow EC2 Instances
======================

Jenkins Server:
  Instance ID: $JENKINS_INSTANCE_ID
  Public IP: $JENKINS_PUBLIC_IP
  SSH: ssh -i ${KEY_NAME}.pem ubuntu@${JENKINS_PUBLIC_IP}
  Jenkins URL: http://${JENKINS_PUBLIC_IP}:8080
  Initial Admin Password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Application Server:
  Instance ID: $APP_INSTANCE_ID
  Public IP: $APP_PUBLIC_IP
  SSH: ssh -i ${KEY_NAME}.pem ubuntu@${APP_PUBLIC_IP}
  Application URL: http://${APP_PUBLIC_IP}

Security Group: $SG_ID
Key Pair: ${KEY_NAME}.pem
Region: $AWS_REGION

Deployment Commands:
  1. SSH to Jenkins: ssh -i ${KEY_NAME}.pem ubuntu@${JENKINS_PUBLIC_IP}
  2. SSH to App Server: ssh -i ${KEY_NAME}.pem ubuntu@${APP_PUBLIC_IP}
  3. Deploy app: docker-compose -f docker-compose.prod.yml up -d
EOL

# Display summary
echo ""
echo "✅ =================================="
echo "✅ EC2 INSTANCES PROVISIONED!"
echo "✅ =================================="
echo ""
cat ec2-instances.txt
echo ""
echo "📝 Instance details saved to: ec2-instances.txt"
echo ""
echo "⚠️  Note: Wait 2-3 minutes for user data scripts to complete."
echo "⚠️  Jenkins initial password: ssh to Jenkins server and run:"
echo "    sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
echo ""
echo "🧹 Cleanup files created:"
echo "  - jenkins-userdata.sh"
echo "  - app-userdata.sh"

# Cleanup
rm -f jenkins-userdata.sh app-userdata.sh

echo ""
echo "✅ Provisioning Complete!"
