#!/bin/bash

# Deployment script for TaskFlow application on EC2
# This script deploys the Docker containers to the EC2 instance

set -e

echo "🚀 TaskFlow Deployment Script"
echo "=============================="

# Configuration
APP_SERVER="${APP_SERVER:-}"
SSH_KEY="${SSH_KEY:-taskflow-key.pem}"
SSH_USER="${SSH_USER:-ec2-user}"
DOCKER_USERNAME="abgyamfi"
IMAGE_TAG="${IMAGE_TAG:-latest}"

# Validate parameters
if [ -z "$APP_SERVER" ]; then
    echo "❌ Error: APP_SERVER environment variable not set"
    echo "Usage: APP_SERVER=<ec2-ip> ./deploy.sh"
    exit 1
fi

if [ ! -f "$SSH_KEY" ]; then
    echo "❌ Error: SSH key file not found: $SSH_KEY"
    exit 1
fi

echo "📋 Deployment Configuration:"
echo "  Server: $APP_SERVER"
echo "  SSH Key: $SSH_KEY"
echo "  Docker Username: $DOCKER_USERNAME"
echo "  Image Tag: $IMAGE_TAG"
echo ""

# Test SSH connection
echo "🔌 Testing SSH connection..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
    "$SSH_USER@$APP_SERVER" "echo '✅ SSH connection successful'" || {
    echo "❌ Failed to connect to $APP_SERVER"
    exit 1
}

# Copy docker-compose file to server
echo ""
echo "📤 Copying docker-compose.prod.yml to server..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no \
    docker-compose.prod.yml \
    "$SSH_USER@$APP_SERVER:~/docker-compose.yml"

echo "✅ File copied successfully"

# Deploy application
echo ""
echo "🚀 Deploying application..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$SSH_USER@$APP_SERVER" bash << EOF
    set -e
    
    echo "📥 Pulling Docker images..."
    docker pull $DOCKER_USERNAME/taskflow-backend:$IMAGE_TAG
    docker pull $DOCKER_USERNAME/taskflow-frontend:$IMAGE_TAG
    
    echo "🛑 Stopping existing containers..."
    docker-compose -f ~/docker-compose.yml down || true
    
    echo "🚀 Starting new containers..."
    REGISTRY_URL=$DOCKER_USERNAME IMAGE_TAG=$IMAGE_TAG docker-compose -f ~/docker-compose.yml up -d
    
    echo "⏳ Waiting for services to start..."
    sleep 10
    
    echo "📊 Container status:"
    docker-compose -f ~/docker-compose.yml ps
    
    echo "🏥 Running health check..."
    for i in {1..10}; do
        if curl -f http://localhost/health &>/dev/null; then
            echo "✅ Application is healthy!"
            break
        fi
        echo "Waiting for application to be ready... (\$i/10)"
        sleep 3
    done
    
    if ! curl -f http://localhost/health &>/dev/null; then
        echo "❌ Health check failed!"
        echo "Checking logs..."
        docker-compose -f ~/docker-compose.yml logs --tail=50
        exit 1
    fi
    
    echo "✅ Deployment completed successfully!"
EOF

# Display deployment info
echo ""
echo "✅ =================================="
echo "✅ DEPLOYMENT SUCCESSFUL!"
echo "✅ =================================="
echo ""
echo "Application URLs:"
echo "  Frontend: http://$APP_SERVER"
echo "  Backend API: http://$APP_SERVER:5000/api/tasks"
echo "  Health Check: http://$APP_SERVER/health"
echo ""
echo "SSH Access:"
echo "  ssh -i $SSH_KEY $SSH_USER@$APP_SERVER"
echo ""
echo "Management Commands:"
echo "  View logs: ssh -i $SSH_KEY $SSH_USER@$APP_SERVER 'docker-compose -f ~/docker-compose.yml logs'"
echo "  Stop app: ssh -i $SSH_KEY $SSH_USER@$APP_SERVER 'docker-compose -f ~/docker-compose.yml down'"
echo "  Restart: ssh -i $SSH_KEY $SSH_USER@$APP_SERVER 'docker-compose -f ~/docker-compose.yml restart'"
echo ""
