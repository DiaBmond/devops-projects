# Project 1: Dockerized Hello World App

## Overview

This project is a **beginner-level DevOps project** that demonstrates containerization using Docker.
It contains:

* **Frontend:** React + TypeScript (Single Page Application)
* **Backend:** Python Django REST API
* **Containerization:** Docker with multi-stage builds

The goal is to learn Docker, build and run containers, and understand how a simple SPA communicates with a REST API.

---

## Architecture

+-----------------+       fetch       +----------------+
|                 | <---------------- |                |
|   React SPA     |                  |  Django REST   |
|   (Frontend)    | ----------------> |   API         |
|  Container      |       JSON        |  Container    |
+-----------------+                   +----------------+
       Port 3000                         Port 8000

* The SPA fetches data from the backend REST API endpoint `/`.
* Both frontend and backend run in separate Docker containers.

---

## Skills Learned

* Dockerfile multi-stage build
* Container lifecycle: build, run, stop, remove
* Simple SPA + REST API
* Understanding of container networking (frontend ↔ backend)

---

## Prerequisites

* Docker installed ([Docker Desktop](https://www.docker.com/products/docker-desktop))
* Node.js (for local testing, optional)
* Python (for local testing, optional)

---

## Run Backend

1. Navigate to backend folder

```bash
cd backend
```

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
# Should return: {"message": "Hello World from Dockerized App!"}
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

* Should display message from backend: `Hello World from Dockerized App!`

---

## Container Lifecycle Commands

* **List running containers**

```bash
docker ps
```

* **Stop containers**

```bash
docker container stop project1-backend-container project1-frontend-container
```

* **Remove containers**

```bash
docker container rm project1-backend-container project1-frontend-container
```

* **Remove images (optional)**

```bash
docker image rm project1-backend project1-frontend
```

---

## Optional: Local Development (without Docker)

* Backend:

```bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py runserver
```

* Frontend:

```bash
cd frontend
npm install
npm start
```

---

## Notes

* This project is intentionally kept **minimal** to focus on Docker skills.
* Multi-container orchestration (docker-compose, network, DB) will be introduced in **Project 3**.
* The frontend container fetches data from the backend container at `http://localhost:8000/`.

---

## Author

* Your Name
* Stage 1 DevOps Portfolio
