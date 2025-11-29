# Project 3: Docker Compose Fullstack

![Docker](https://img.shields.io/badge/docker-24.0+-blue)
![Docker Compose](https://img.shields.io/badge/docker--compose-v2-blue)
![Python](https://img.shields.io/badge/python-3.12-blue)
![Node](https://img.shields.io/badge/node-20.x-green)
![PostgreSQL](https://img.shields.io/badge/postgresql-16-blue)
![Redis](https://img.shields.io/badge/redis-7-red)
![Nginx](https://img.shields.io/badge/nginx-alpine-green)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Overview

A **production-like full-stack application** demonstrating multi-container orchestration with Docker Compose. This project integrates PostgreSQL database, Redis cache, Django backend, React frontend, and Nginx reverse proxy.

**Tech Stack:**
- **Frontend**: React 18 + TypeScript
- **Backend**: Python 3.12 + Django 5.0
- **Database**: PostgreSQL 16
- **Cache**: Redis 7
- **Reverse Proxy**: Nginx (Alpine)
- **Orchestration**: Docker Compose

**Learning Path**: This is **Project 3 of 10** in the DevOps Roadmap (Stage 1: Beginner).

---

## Architecture
```
┌─────────────────────────────────────────┐
│      FULL-STACK ARCHITECTURE            │
└─────────────────────────────────────────┘

          [User Browser]
                ↓
          [Nginx :80]  ← Reverse Proxy
                ↓
          ┌─────┴─────┐
          ↓           ↓
    [Frontend]   [Backend API]
      :3000        :8000
                    ↓
              ┌─────┴─────┐
              ↓           ↓
        [PostgreSQL]  [Redis]
          :5432       :6379
              ↓           ↓
          [Volume]    [Volume]
      (data persist) (cache)
```

### Network Topology
```
backend-network:
  - postgres
  - redis
  - backend

frontend-network:
  - backend
  - frontend
  - nginx
```

---

## Learning Objectives

After completing this project, you will understand:

- **Multi-container orchestration** with Docker Compose
- **Service dependencies** and health checks
- **PostgreSQL** integration with Django
- **Redis** caching implementation
- **Nginx** as reverse proxy and load balancer
- **Docker networks** for service isolation
- **Volume management** for data persistence
- **Environment variable** management
- **Development vs Production** configurations

---

## Quick Start

### Prerequisites

- Docker Desktop installed ([Download](https://www.docker.com/products/docker-desktop/))
- Docker Compose v2+
- 4GB+ RAM available
- Ports 80, 3000, 5432, 8000 available

### 1. Clone Repository
```bash
git clone https://github.com/DiaBmond/devops-projects.git
cd devops-projects/project-03-docker-compose-fullstack
```

### 2. Setup Environment Variables
```bash
# Copy example env file
cp .env.example .env

# .env file contents (already set for development):
# POSTGRES_DB=appdb
# POSTGRES_USER=appuser
# POSTGRES_PASSWORD=devpassword123
# REDIS_PASSWORD=redispass123
# DJANGO_SECRET_KEY=dev-secret-key-change-in-production
# DJANGO_DEBUG=True
# DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,backend
```

**Important**: Never commit `.env` file to Git (already in `.gitignore`)

### 3. Start All Services
```bash
# Build and start all services
docker-compose up --build

# Or run in background
docker-compose up -d --build
```

### 4. Access Application

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost/ | React App (via Nginx) |
| **Backend API** | http://localhost/api/ | Django API (via Nginx) |
| **Health Check** | http://localhost/health | Nginx health endpoint |
| **Direct Frontend** | http://localhost:3000 | React Dev Server (dev only) |
| **Direct Backend** | http://localhost:8000 | Django Server (dev only) |

**Expected Output:**
```
Frontend: "Hello World from Dockerized App!" with tech badges
Backend API: {"message": "Hello World from Dockerized App!"}
Health: healthy
```

---

## Project Structure
```
project-03-docker-compose-fullstack/
├── backend/
│   ├── api/                      # Django app
│   │   ├── __init__.py
│   │   ├── admin.py
│   │   ├── apps.py
│   │   ├── models.py
│   │   ├── urls.py
│   │   └── views.py
│   ├── backend/                  # Django project
│   │   ├── __init__.py
│   │   ├── settings.py          # PostgreSQL + Redis config
│   │   ├── urls.py
│   │   └── wsgi.py
│   ├── tests/
│   ├── Dockerfile               # Production-ready
│   ├── manage.py
│   ├── requirements.txt
│   └── requirements-dev.txt
│
├── frontend/
│   ├── public/
│   ├── src/
│   │   ├── App.tsx              # Main component
│   │   ├── App.css
│   │   └── index.tsx
│   ├── Dockerfile               # Production build
│   ├── Dockerfile.dev           # Development with hot reload
│   ├── package.json
│   └── tsconfig.json
│
├── nginx/
│   └── nginx.conf               # Reverse proxy configuration
│
├── docker-compose.yml           # Orchestration config
├── .env.example                 # Environment template
├── .env                         # Actual env (gitignored)
├── .gitignore
└── README.md
```

---

## Services Overview

### 1. PostgreSQL (Database)
```yaml
Container: project3-postgres
Image: postgres:16-alpine
Port: 5432
Volume: postgres_data
Health Check: pg_isready
```

**Features:**
- Persistent data storage
- Health checks
- Automatic database creation
- Resource limits

### 2. Redis (Cache)
```yaml
Container: project3-redis
Image: redis:7-alpine
Port: 6379 (internal)
Volume: redis_data
Health Check: redis-cli ping
```

**Features:**
- Password authentication
- AOF persistence
- Health checks
- Resource limits

### 3. Django Backend (API)
```yaml
Container: project3-backend
Build: ./backend/Dockerfile
Port: 8000
Depends on: postgres, redis
```

**Features:**
- PostgreSQL database integration
- Redis cache integration
- Automatic migrations on startup
- Environment-based configuration
- Hot reload in development

**API Endpoints:**
- `GET /` - Hello World message
- `GET /admin/` - Django admin panel

### 4. React Frontend (UI)
```yaml
Container: project3-frontend
Build: ./frontend/Dockerfile.dev
Port: 3000
```

**Features:**
- TypeScript support
- Hot module replacement
- Environment variables
- Connects to backend via Nginx

### 5. Nginx (Reverse Proxy)
```yaml
Container: project3-nginx
Image: nginx:alpine
Port: 80
```

**Routing:**
- `/` → Frontend (React)
- `/api/` → Backend (Django)
- `/health` → Health check

---

## Docker Compose Commands

### Basic Operations
```bash
# Start all services
docker-compose up

# Start in background
docker-compose up -d

# Build and start
docker-compose up --build

# Stop services
docker-compose stop

# Stop and remove containers
docker-compose down

# Stop and remove containers + volumes (deletes data)
docker-compose down -v

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
```

### Service Management
```bash
# List running services
docker-compose ps

# Check service health
docker-compose ps

# Restart specific service
docker-compose restart backend

# Rebuild specific service
docker-compose up -d --build backend

# Scale service (if configured)
docker-compose up -d --scale backend=3
```

### Database Operations
```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U appuser -d appdb

# View tables
docker-compose exec postgres psql -U appuser -d appdb -c "\dt"

# Run migrations manually
docker-compose exec backend python manage.py migrate

# Create superuser
docker-compose exec backend python manage.py createsuperuser
```

### Redis Operations
```bash
# Connect to Redis
docker-compose exec redis redis-cli -a redispass123

# Test Redis
docker-compose exec redis redis-cli -a redispass123 PING
# Response: PONG

# Set/Get keys
docker-compose exec redis redis-cli -a redispass123
> SET test "Hello Redis"
> GET test
```

### Container Inspection
```bash
# View container stats
docker stats

# Inspect container
docker inspect project3-backend

# Execute command in container
docker-compose exec backend bash

# View environment variables
docker-compose exec backend env
```

---

## Development Workflow

### 1. Start Development Environment
```bash
# Start all services with logs
docker-compose up --build
```

### 2. Make Code Changes

**Backend changes:**
- Edit files in `backend/`
- Django auto-reloads (no restart needed)

**Frontend changes:**
- Edit files in `frontend/src/`
- React hot-reloads automatically

**Nginx config changes:**
- Edit `nginx/nginx.conf`
- Restart nginx: `docker-compose restart nginx`

### 3. View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
```

### 4. Test Changes
```bash
# Backend API
curl http://localhost/api/

# Frontend
open http://localhost/

# Health check
curl http://localhost/health
```

---

## Testing

### Backend Tests
```bash
# Run pytest
docker-compose exec backend pytest

# With coverage
docker-compose exec backend pytest --cov

# Specific test file
docker-compose exec backend pytest tests/test_api.py -v
```

### Frontend Tests
```bash
# Run Jest tests
docker-compose exec frontend npm test

# With coverage
docker-compose exec frontend npm test -- --coverage
```

---

## Troubleshooting

### Port Already in Use

**Error:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use
```

**Solution:**
```bash
# Find process using port
lsof -i :80

# Kill process
kill -9 <PID>

# Or change port in docker-compose.yml
ports:
  - "8080:80"
```

### Database Connection Failed

**Error:**
```
django.db.utils.OperationalError: connection to server failed
```

**Solution:**
```bash
# Check postgres is healthy
docker-compose ps

# Check logs
docker-compose logs postgres

# Restart services
docker-compose down
docker-compose up -d
```

### Frontend Cannot Reach Backend

**Error:**
```
Failed to fetch
```

**Solution:**
1. Check backend is running: `curl http://localhost/api/`
2. Check nginx config: `docker-compose exec nginx cat /etc/nginx/nginx.conf`
3. Check browser console for CORS errors
4. Verify frontend uses `/api/` not `http://localhost:8000`

### Container Exits Immediately

**Check logs:**
```bash
docker-compose logs <service-name>
```

**Common issues:**
- Missing dependencies
- Configuration errors
- Port conflicts
- Volume permission issues

### Reset Everything
```bash
# Nuclear option - reset everything
docker-compose down -v
docker system prune -a --volumes
docker-compose up --build
```

---

## Environment Variables

### PostgreSQL
```bash
POSTGRES_DB=appdb              # Database name
POSTGRES_USER=appuser          # Username
POSTGRES_PASSWORD=password123   # Password
```

### Redis
```bash
REDIS_PASSWORD=redispass123    # Redis password
```

### Django
```bash
DJANGO_SECRET_KEY=secret-key-here
DJANGO_DEBUG=True              # True for dev, False for prod
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1,backend
```

### Frontend
```bash
REACT_APP_API_URL=http://localhost/api  # Backend API URL
```

---

## Production Considerations

### Security Improvements
```yaml
# Use secrets instead of env vars
secrets:
  db_password:
    file: ./secrets/db_password.txt

# Set resource limits
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
```

### Performance Optimization
```yaml
# Use production Dockerfile for frontend
frontend:
  build:
    context: ./frontend
    dockerfile: Dockerfile  # Multi-stage build

# Enable Nginx caching
# Add to nginx.conf
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m;
```

### Monitoring
```yaml
# Add health checks to all services
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

---

## What You Learned

### Docker Concepts

- **Multi-container orchestration**: Managing 5 services together
- **Service dependencies**: Using `depends_on` with health checks
- **Networks**: Isolating services with custom networks
- **Volumes**: Persisting data across container restarts
- **Health checks**: Monitoring service availability

### Infrastructure Patterns

- **Reverse Proxy**: Nginx routing requests
- **Database Integration**: PostgreSQL with Django
- **Caching Layer**: Redis for performance
- **Environment Management**: Using .env files
- **Development vs Production**: Different configurations

### Best Practices

- **Security**: Password protection, non-root users
- **Data Persistence**: Named volumes for databases
- **Service Discovery**: Using service names as hostnames
- **Configuration Management**: Environment variables
- **Logging**: Centralized log viewing

---

## Common Commands Reference
```bash
# Quick reference card
docker-compose up -d              # Start services
docker-compose down               # Stop services
docker-compose logs -f            # View logs
docker-compose ps                 # Service status
docker-compose restart <service>  # Restart service
docker-compose exec <service> sh  # Shell into container

# Database
docker-compose exec postgres psql -U appuser -d appdb

# Backend
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py shell

# Redis
docker-compose exec redis redis-cli -a redispass123
```

---

## Next Steps

### Improvements to Try

1. **Add SSL/TLS** - Configure Nginx with HTTPS
2. **Add Monitoring** - Integrate Prometheus + Grafana
3. **Add Logging** - Centralized logging with ELK/Loki
4. **Add CI/CD** - Automated testing and deployment
5. **Add Backups** - Database backup scripts
6. **Add Scaling** - Multiple backend instances

### Next Project

**[Project 4: Infrastructure as Code with Terraform](../project-04-terraform-aws-infra)**

You'll learn:
- Terraform basics
- AWS infrastructure provisioning
- VPC, Subnets, Security Groups
- Infrastructure automation
- State management

---

## Resources & References

### Official Documentation
- [Docker Compose Docs](https://docs.docker.com/compose/)
- [PostgreSQL Docker](https://hub.docker.com/_/postgres)
- [Redis Docker](https://hub.docker.com/_/redis)
- [Nginx Docs](https://nginx.org/en/docs/)
- [Django Documentation](https://docs.djangoproject.com/)
- [React Documentation](https://react.dev/)

### Tutorials
- [Docker Compose Tutorial](https://docs.docker.com/compose/gettingstarted/)
- [Nginx Reverse Proxy Guide](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [Django + PostgreSQL Setup](https://docs.djangoproject.com/en/5.0/ref/databases/#postgresql-notes)

---

## Author

**KODCHAMON BOONCHAN (DiaBmond)**  
DevOps Learning Journey - Project 3/10 (Stage 1: Beginner)  
[GitHub Profile](https://github.com/DiaBmond) | [All Projects](https://github.com/DiaBmond/devops-projects)

---

## License

MIT License - Feel free to use this project for learning purposes.

---

## Achievement Unlocked

**Full-Stack Orchestration Mastered**
- Deployed multi-container application
- Integrated database and cache
- Configured reverse proxy
- Managed service dependencies
- Implemented health checks
- Applied production patterns

**Ready for:** Project 4 - Infrastructure as Code

---

## Support

Found a bug or have a question?
1. Check [Troubleshooting](#troubleshooting) section
2. Review logs: `docker-compose logs`
3. Open an issue on [GitHub](https://github.com/DiaBmond/devops-projects/issues)

---

**Happy Learning!**