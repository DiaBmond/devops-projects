# Project 1: Dockerized Hello World App

## Overview

This project is a **beginner-level DevOps project** that demonstrates containerization using Docker.
It contains:

* **Frontend:** React + TypeScript (Single Page Application)
* **Backend:** Python Django REST API
* **Containerization:** Docker with multi-stage builds

The goal is to learn Docker, build and run containers

---

## Skills Learned

* Dockerfile multi-stage build
* Container lifecycle: build, run, stop, remove
* Understanding of container networking (frontend ↔ backend)

---


## Run Backend

1. Navigate to backend folder
cd backend


2. Build Docker image
docker image build -t project1-backend .

3. Run container
docker container run -d --name project1-backend-container -p 8000:8000 project1-backend

4. Test backend API

curl http://localhost:8000/
# Should return: {"message": "Hello World from Dockerized App!"}


---

## Run Frontend

1. Navigate to frontend folder
cd frontend

2. Build Docker image (multi-stage)
docker image build -t project1-frontend .

3. Run container
docker container run -d --name project1-frontend-container -p 3000:80 project1-frontend

4. Open browser
http://localhost:3000

* Should display message from backend: `Hello World from Dockerized App!`

---

## Container Lifecycle Commands

* **List running containers**

docker ps

* **Stop containers**

docker container stop project1-backend-container project1-frontend-container


* **Remove containers**

docker container rm -f project1-backend-container project1-frontend-container


* **Remove images (optional)**

docker image rm -f project1-backend project1-frontend

---

## Run with Docker Compose

1. Ensure you are in the project root where `docker-compose.yml` exists.

2. Build and run containers
docker-compose up --build

* This builds the images and runs the frontend and backend containers.
* Terminal will stream logs from both containers.

3. Run in background (detached mode)
docker-compose up --build -d

4. Stop and remove containers
docker-compose down

## Notes

* This project is intentionally kept **minimal** to focus on Docker skills.
* The frontend container fetches data from the backend container at `http://localhost:8000/`.

## Optional local dev
# Backend
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py runserver

# Frontend
cd frontend
npm install
npm start

## Author
* KODCHAMON BOONCHAN
* Stage 1 DevOps