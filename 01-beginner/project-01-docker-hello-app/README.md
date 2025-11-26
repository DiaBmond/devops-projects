# Project 1: Dockerized Hello World App

## Overview

This project is a beginner-level DevOps project demonstrating containerization using Docker.  
It contains:

* Frontend: React + TypeScript (SPA)
* Backend: Python Django REST API
* Containerization: Docker with multi-stage builds

Goal: Learn Docker, build and run containers.

---

## Skills Learned

* Dockerfile multi-stage build
* Container lifecycle: build, run, stop, remove
* Container networking (frontend ↔ backend)

---

## Run Backend

1. Navigate to backend folder

```bash
cd backend
````

2. Build Docker image

```bash
docker image build -t project1-backend .
```

3. Run container

```bash
docker container run -d --name project1-backend-container -p 8000:8000 project1-backend
```

4. Test backend API

```bash
curl http://localhost:8000/
# Expected: {"message": "Hello World from Dockerized App!"}
```

---

## Run Frontend

1. Navigate to frontend folder

```bash
cd frontend
```

2. Build Docker image (multi-stage)

```bash
docker image build -t project1-frontend .
```

3. Run container

```bash
docker container run -d --name project1-frontend-container -p 3000:80 project1-frontend
```

4. Open browser

```
http://localhost:3000
```

* Should display: "Hello World from Dockerized App!"

---

## Container Lifecycle Commands

**List running containers**

```bash
docker ps
```

**Stop containers**

```bash
docker container stop project1-backend-container project1-frontend-container
```

**Remove containers**

```bash
docker container rm -f project1-backend-container project1-frontend-container
```

**Remove images (optional)**

```bash
docker image rm -f project1-backend project1-frontend
```

---

## Run with Docker Compose

1. Ensure you are at project root (where docker-compose.yml exists)

2. Build and run containers

```bash
docker-compose up --build
```

3. Run in detached mode

```bash
docker-compose up --build -d
```

4. Stop and remove containers

```bash
docker-compose down
```

---

## Optional Local Development

**Backend**

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py runserver
```

**Frontend**

```bash
cd frontend
npm install
npm start
```

---

## Author

* KODCHAMON BOONCHAN
* Stage 1 DevOps