# Project 1: Dockerized Hello World App

![Docker](https://img.shields.io/badge/docker-24.0+-blue)
![Python](https://img.shields.io/badge/python-3.12-blue)
![Node](https://img.shields.io/badge/node-20.x-green)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## 📋 Overview

A beginner-level DevOps project demonstrating **containerization fundamentals** using Docker. This project serves as the foundation for the entire DevOps learning journey.

**Tech Stack:**
- **Frontend**: React 18 + TypeScript + Vite
- **Backend**: Python 3.12 + Django 5.0
- **Containerization**: Docker with multi-stage builds

**Learning Path**: This is **Project 1 of 10** in the DevOps Roadmap (Stage 1: Beginner).

---

## 🎯 Learning Objectives

After completing this project, you will understand:

- Docker fundamentals (images, containers, layers)
- Multi-stage Dockerfile patterns
- Container networking (port mapping)
- Docker Compose basics
- Image optimization techniques
- Container lifecycle management

---

## Quick Start

### Prerequisites

- Docker Desktop installed ([Download](https://www.docker.com/products/docker-desktop/))
- Docker Compose included with Docker Desktop
- 4GB+ RAM available for containers

### Option 1: Run with Docker Compose (Recommended)

```bash
# 1. Clone the repository (if not already)
git clone https://github.com/DiaBmond/devops-projects.git
cd devops-projects/01-beginner/project-01-docker-hello-app

# 2. Build and start all services
docker-compose up --build

# 3. Access the application
# Frontend: http://localhost:3000
# Backend:  http://localhost:8000
```

**Expected Output:**
```
Backend API: {"message": "Hello World from Dockerized App!"}
Frontend: Displays the message with styled UI
```

**Stop services:**
```bash
# Stop and remove containers
docker-compose down

# Stop and remove containers + volumes
docker-compose down -v
```

---

### Option 2: Run Containers Individually

#### Backend Container

```bash
# Navigate to backend
cd backend

# Build image
docker build -t project1-backend .

# Run container
docker run -d --name project1-backend-container -p 8000:8000 project1-backend

# Test API
curl http://localhost:8000/
# Response: {"message": "Hello World from Dockerized App!"}

# View logs
docker logs project1-backend-container

# Stop and remove
docker stop project1-backend-container
docker rm project1-backend-container
```

#### Frontend Container

```bash
# Navigate to frontend
cd frontend

# Build image (multi-stage)
docker build -t project1-frontend .

# Run container
docker run -d --name project1-frontend-container -p 3000:80 project1-frontend

# Test
open http://localhost:3000

# View logs
docker logs project1-frontend-container

# Stop and remove
docker stop project1-frontend-container
docker rm project1-frontend-container
```

---

## Container Management Commands

### Inspect Running Containers

```bash
# List all running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Inspect container details
docker inspect project1-backend-container

# View resource usage
docker stats
```

### Logs & Debugging

```bash
# View logs
docker logs project1-backend-container

# Follow logs in real-time
docker logs -f project1-backend-container

# Last 50 lines
docker logs --tail 50 project1-backend-container

# Execute command inside container
docker exec -it project1-backend-container bash

# Check running processes
docker top project1-backend-container
```

### Cleanup

```bash
# Stop all project containers
docker stop project1-backend-container project1-frontend-container

# Remove containers
docker rm project1-backend-container project1-frontend-container

# Remove images
docker rmi project1-backend project1-frontend

# Prune unused resources (be careful!)
docker system prune -a --volumes
```

---

## Troubleshooting

### Port Already in Use

**Error:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:8000: bind: address already in use
```

**Solution:**
```bash
# Find process using port 8000
lsof -i :8000

# Kill the process
kill -9 <PID>

# Or change port
docker run -p 8001:8000 project1-backend
```

### Container Exits Immediately

**Check logs:**
```bash
docker logs project1-backend-container
```

**Common issues:**
- Missing dependencies in requirements.txt
- Syntax errors in Python code
- Wrong WORKDIR path

### Image Build Fails

**Backend build fails:**
```bash
# Build with no cache to debug
docker build --no-cache -t project1-backend .

# Common issues:
# - requirements.txt missing
# - Python version mismatch
# - Network issues during pip install
```

**Frontend build fails:**
```bash
# Clear npm cache
npm cache clean --force

# Build again
docker build --no-cache -t project1-frontend .
```

---

## What You Learned

### Docker Fundamentals

- **Images vs Containers**: Images are blueprints, containers are running instances
- **Dockerfile**: Instructions to build images
- **Multi-stage builds**: Optimize image size
- **Port mapping**: Connect host ports to container ports (-p host:container)

---

## Local Development (Without Docker)

If you want to run without containers:

### Backend

```bash
cd backend

# Create virtual environment
python -m venv venv

# Activate (macOS/Linux)
source venv/bin/activate

# Activate (Windows)
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run development server
python manage.py runserver

# Access: http://localhost:8000
```

### Frontend

```bash
cd frontend

# Install dependencies
npm install

# Start dev server
npm run dev

# Access: http://localhost:5173 (Vite default)
```

---

## Next Project

**[Project 2: CI/CD Pipeline with GitHub Actions](../project-02-ci-pipeline-demo)**

You'll add:
- Automated testing (pytest, Jest)
- GitHub Actions workflows
- Build automation
- Status badges

---

## Resources

- [Docker Documentation](https://docs.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [Multi-stage Builds](https://docs.docker.com/build/building/multi-stage/)

---

## Author

**KODCHAMON BOONCHAN**  
DevOps Learning Journey - Project 1/10 (Stage 1: Beginner)  
[GitHub Profile](https://github.com/DiaBmond) | [All Projects](https://github.com/DiaBmond/devops-projects)

---

## License

MIT License - Feel free to use this project for learning purposes.

---

## Achievement Unlocked

**Docker Basics Mastered**
- Built first Docker images
- Ran containers successfully
- Learned multi-stage builds
- Used Docker Compose

**Ready for:** Project 2 - CI/CD Pipeline