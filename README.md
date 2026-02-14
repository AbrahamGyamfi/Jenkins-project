# TaskFlow - Task Management Web Application

[![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-red)](https://jenkins.io/)
[![Docker](https://img.shields.io/badge/Container-Docker-blue)](https://www.docker.com/)
[![AWS](https://img.shields.io/badge/Deploy-AWS%20EC2-orange)](https://aws.amazon.com/ec2/)

A lightweight, intuitive task management web application built following Agile principles and DevOps practices.

## 📋 Project Overview

TaskFlow is a full-stack task management application developed as part of an Agile Development project. The application demonstrates:

- **Agile Methodology**: Iterative development across multiple sprints
- **DevOps Practices**: Complete Jenkins CI/CD pipeline with Docker & EC2 deployment
- **Modern Web Stack**: React frontend with Node.js/Express backend
- **Test-Driven Development**: High code coverage with automated tests
- **Containerization**: Docker multi-stage builds for production deployment

## 🚀 Features

### Sprint 1 Features (Completed)
- ✅ **US-001**: Create tasks with title and description
- ✅ **US-002**: View all tasks in a organized list
- ✅ **US-003**: Mark tasks as complete/incomplete

### Sprint 2 Features (Completed)
- ✅ **US-004**: Delete tasks with confirmation
- ✅ **US-005**: Edit existing task details
- ✅ **US-006**: Filter tasks by status (All/Active/Completed)

## 🛠️ Technology Stack

### Frontend
- React 18
- CSS3 (with CSS Modules)
- Fetch API for HTTP requests

### Backend
- Node.js
- Express.js
- UUID for unique identifiers
- CORS for cross-origin requests

### DevOps & Testing
- Jest for unit and integration testing
- Supertest for API testing
- **Jenkins** for complete CI/CD pipeline
- **Docker** for containerization
- **AWS EC2** for production deployment
- ESLint for code quality

## 📦 Installation & Setup

### Prerequisites
- Node.js 18+ and npm
- Git
- Docker (for containerized deployment)
- Jenkins (for CI/CD pipeline)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Agile_development
   ```

2. **Install backend dependencies**
   ```bash
   npm install
   ```

3. **Install frontend dependencies**
   ```bash
   cd frontend
   npm install
   cd ..
   ```

4. **Run tests**
   ```bash
   npm test
   ```

5. **Start the backend server**
   ```bash
   npm start
   # Server runs on http://localhost:5000
   ```

6. **Start the frontend (in a new terminal)**
   ```bash
   cd frontend
   npm start
   # Frontend runs on http://localhost:3000
   ```

7. **Access the application**
   Open your browser and navigate to `http://localhost:3000`

## 🧪 Testing

### Run all tests
```bash
npm test
```

### Run tests with coverage
```bash
npm test -- --coverage
```

### Test Coverage Goals
- Minimum 80% code coverage across all metrics
- All tests must pass before merging to main branch

## 🔄 CI/CD Pipeline (Jenkins)

The project implements a complete end-to-end Jenkins CI/CD pipeline that builds, tests, containerizes, and deploys the application to AWS EC2.

### Pipeline Stages
1. **Checkout**: Clone repository from Git
2. **Install Dependencies**: Install backend and frontend dependencies
3. **Build**: Build React frontend application
4. **Test**: Run Jest unit tests with coverage reporting
5. **Docker Build**: Create Docker image with multi-stage build
6. **Docker Test**: Test container health before deployment
7. **Push to Registry**: Push image to Docker Hub/AWS ECR
8. **Deploy to EC2**: SSH deployment to EC2 instance
9. **Cleanup**: Remove old images and containers

### Key Features
- ✅ Automated testing with >90% coverage requirement
- ✅ Docker containerization for consistent deployments
- ✅ Health checks before and after deployment
- ✅ Automated rollback on failure
- ✅ Build artifacts and test reports published
- ✅ Image versioning with build numbers

### Jenkins Setup
See [JENKINS_SETUP.md](JENKINS_SETUP.md) for complete pipeline configuration instructions.

### CI/CD Evidence
See [CI_CD_EVIDENCE.md](CI_CD_EVIDENCE.md) for pipeline run screenshots and logs.

## 🐳 Docker Deployment

### Build Docker Image
```bash
docker build -t taskflow-app .
```

### Run Container Locally
```bash
docker run -d -p 5000:5000 taskflow-app
```

### Using Docker Compose
```bash
# Development
docker-compose up -d

# Production (on EC2)
docker-compose -f docker-compose.prod.yml up -d
```

### Health Check
```bash
curl http://localhost:5000/health
```

## 📊 Project Structure

```
Agile_development/
├── backend/
│   └── server.js              # Express server and API routes
├── frontend/
│   ├── public/
│   │   └── index.html         # HTML template
│   └── src/
│       ├── components/        # React components
│       │   ├── TaskForm.js
│       │   ├── TaskList.js
│       │   ├── TaskItem.js
│       │   └── TaskFilter.js
│       ├── App.js             # Main application component
│       ├── App.css            # Global styles
│       └── index.js           # React entry point
├── __tests__/
│   └── api.test.js            # API integration tests
├── Jenkinsfile                # Jenkins pipeline configuration
├── Dockerfile                 # Multi-stage Docker build
├── .dockerignore              # Docker ignore rules
├── docker-compose.yml         # Docker compose for development
├── docker-compose.prod.yml    # Docker compose for production
├── JENKINS_SETUP.md           # Complete Jenkins setup guide
├── CI_CD_EVIDENCE.md          # Pipeline evidence and screenshots
├── docs/                      # Documentation directory
│   ├── SPRINT_0_PLANNING.md   # Sprint 0 planning documents
│   ├── SPRINT_1_REVIEW.md     # Sprint 1 review and retrospective
│   └── SPRINT_2_REVIEW.md     # Sprint 2 review and retrospective
├── package.json               # Backend dependencies
├── jest.config.js             # Jest configuration
└── README.md                  # This file
```

## 📈 Agile Process

### Sprint Structure
- **Sprint 0**: Planning and setup
- **Sprint 1**: Core features + CI/CD setup
- **Sprint 2**: Additional features + monitoring

### Sprint Documents
- [Sprint 0 Planning](docs/SPRINT_0_PLANNING.md)
- [Sprint 1 Review & Retrospective](docs/SPRINT_1_REVIEW.md)
- [Sprint 2 Review & Retrospective](docs/SPRINT_2_REVIEW.md)

### Definition of Done
1. ✅ Code complete and reviewed
2. ✅ All tests passing with >80% coverage
3. ✅ CI pipeline green
4. ✅ Feature works per acceptance criteria
5. ✅ Code follows quality standards
6. ✅ Documentation updated
7. ✅ No critical bugs

## 🔍 API Endpoints

### Tasks
- `POST /api/tasks` - Create a new task
- `GET /api/tasks` - Get all tasks
- `PATCH /api/tasks/:id` - Update task status
- `PUT /api/tasks/:id` - Edit task details
- `DELETE /api/tasks/:id` - Delete a task

### Monitoring
- `GET /health` - Health check endpoint

## 📝 Development Guidelines

### Branching Strategy
- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches

### Commit Message Format
```
<type>: <subject>

<body>

Example:
feat: Add task filtering by status (US-006)

Implemented filter component with All, Active, and Completed tabs
```

### Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `test`: Adding or updating tests
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `style`: Code style changes
- `chore`: Build or auxiliary tool changes

## 🎯 Learning Outcomes

This project demonstrates:
1. ✅ Application of Agile principles (user stories, sprints, retrospectives)
2. ✅ DevOps practices (CI/CD, automated testing, monitoring)
3. ✅ Iterative development with incremental delivery
4. ✅ Test-driven development approach
5. ✅ Git workflow with meaningful commit history
6. ✅ Code quality and documentation standards

## 👥 Contributing

This is an individual project for academic assessment. Contributions are not accepted.

## 📄 License

MIT License - This is an educational project.

## 📞 Support

For issues or questions, please refer to the project documentation or contact the project maintainer.

---

**Project Date**: February 2026  
**Version**: 1.0.0  
**Status**: ✅ Completed
