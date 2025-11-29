# Project 3: Docker Compose Fullstack (WIP)

> 🚧 **Status**: Planning Phase  
> 📅 **Planned Start**: TBD  
> 🎯 **Goal**: Build production-like multi-container environment

---

## Overview

Full-stack application with multiple services orchestrated using Docker Compose, demonstrating real-world application architecture with database, caching, and reverse proxy.

This project applies all best practices from Project 1 and integrates CI/CD from Project 2.

---

## Planned Architecture
```
┌─────────────────────────────────────────────────┐
│         FULL-STACK ARCHITECTURE                 │
└─────────────────────────────────────────────────┘

     [User Browser]
            │
            ▼
     ┌──────────────┐
     │    Nginx     │  Reverse Proxy
     │   Port 80    │  SSL-ready
     └──────┬───────┘
            │
      ┌─────┴─────┐
      │           │
      ▼           ▼
┌──────────┐  ┌──────────┐
│ Frontend │  │ Backend  │
│  React   │  │  Django  │
│ :3000    │  │  :8000   │
└──────────┘  └────┬─────┘
                   │
              ┌────┴────┐
              │         │
              ▼         ▼
        ┌──────────┐ ┌──────────┐
        │PostgreSQL│ │  Redis   │
        │  :5432   │ │  :6379   │
        └────┬─────┘ └────┬─────┘
             │            │
        [Volume]      [Volume]
     (data persist) (cache data)
```

---

## Planned Features

### Core Services
- ✅ **Backend API** - Django REST Framework
- ✅ **Frontend** - React TypeScript SPA
- ✅ **Database** - PostgreSQL (persistent storage)
- ✅ **Cache** - Redis (session & data caching)
- ✅ **Reverse Proxy** - Nginx (routing & load balancing)

### DevOps Features
- ✅ **Multi-stage Builds** - Optimized Docker images
- ✅ **Health Checks** - All services monitored
- ✅ **Non-root Users** - Security best practices
- ✅ **Volume Management** - Data persistence
- ✅ **Network Isolation** - Custom Docker networks
- ✅ **Environment Variables** - Configuration management
- ✅ **Development Mode** - Hot reload for coding
- ✅ **Production Mode** - Optimized for deployment

---

## Skills to Learn

### Docker Compose
- [ ] Service orchestration
- [ ] Multi-container networking
- [ ] Volume management (named volumes, bind mounts)
- [ ] Environment variable handling
- [ ] Service dependencies (depends_on, healthcheck)
- [ ] Override files (docker-compose.override.yml)
- [ ] Resource limits

### Database Integration
- [ ] PostgreSQL setup in containers
- [ ] Database initialization scripts
- [ ] Connection pooling
- [ ] Data persistence strategies
- [ ] Database migrations
- [ ] Backup strategies

### Caching Layer
- [ ] Redis integration
- [ ] Session management
- [ ] Data caching patterns
- [ ] Cache invalidation
- [ ] Redis persistence options

### Reverse Proxy
- [ ] Nginx configuration
- [ ] Request routing
- [ ] Load balancing basics
- [ ] SSL/TLS setup (Let's Encrypt ready)
- [ ] Static file serving
- [ ] Proxy headers

### Production Patterns
- [ ] Logging strategy
- [ ] Monitoring readiness
- [ ] Graceful shutdown
- [ ] Restart policies
- [ ] Secret management
- [ ] Multi-environment support

---

## Planned Project Structure
```
docker-compose-fullstack/
├── .github/
│   └── workflows/
│       └── ci.yml                # CI/CD pipeline (from Project 2)
│
├── backend/
│   ├── Dockerfile                # Production (multi-stage)
│   ├── Dockerfile.dev            # Development (hot reload)
│   ├── requirements.txt
│   ├── requirements-dev.txt
│   ├── .dockerignore
│   ├── manage.py
│   ├── api/
│   │   ├── settings/
│   │   │   ├── base.py
│   │   │   ├── development.py
│   │   │   └── production.py
│   │   ├── models.py            # Database models
│   │   ├── views.py
│   │   └── urls.py
│   └── tests/
│
├── frontend/
│   ├── Dockerfile                # Production (Nginx)
│   ├── Dockerfile.dev            # Development (React dev server)
│   ├── .dockerignore
│   ├── package.json
│   ├── src/
│   │   ├── api/
│   │   │   └── client.ts        # API integration
│   │   ├── App.tsx
│   │   └── config.ts            # Environment config
│   └── public/
│
├── nginx/
│   ├── Dockerfile
│   ├── nginx.conf                # Main config
│   ├── conf.d/
│   │   ├── default.conf         # Routing rules
│   │   └── ssl.conf             # SSL config (future)
│   └── html/
│       └── 50x.html             # Error pages
│
├── postgres/
│   ├── Dockerfile (optional)
│   └── init/
│       ├── 01-init.sql          # Schema
│       └── 02-seed.sql          # Sample data
│
├── redis/
│   └── redis.conf               # Redis configuration
│
├── docker-compose.yml           # Production setup
├── docker-compose.dev.yml       # Development overrides
├── docker-compose.test.yml      # Testing environment
│
├── .env.example                 # Environment template
├── .env.dev                     # Development env (gitignored)
├── .env.prod                    # Production env (gitignored)
│
├── scripts/
│   ├── setup.sh                 # Initial setup
│   ├── backup-db.sh             # Database backup
│   ├── restore-db.sh            # Database restore
│   └── healthcheck.sh           # Manual health check
│
├── .gitignore
└── README.md
```

---

## Planned docker-compose.yml Structure
```yaml
version: '3.9'

services:
  # Database
  postgres:
    image: postgres:16-alpine
    container_name: fullstack-db
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./postgres/init:/docker-entrypoint-initdb.d
    networks:
      - backend-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 10s
      timeout: 5s
      retries: 5

  # Cache
  redis:
    image: redis:7-alpine
    container_name: fullstack-cache
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data
    networks:
      - backend-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: fullstack-backend
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
    environment:
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@postgres:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379/0
    volumes:
      - ./backend:/app
      - backend_static:/app/staticfiles
    networks:
      - backend-network
      - frontend-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 5s
      retries: 3

  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: fullstack-frontend
    depends_on:
      - backend
    networks:
      - frontend-network

  # Reverse Proxy
  nginx:
    build:
      context: ./nginx
      dockerfile: Dockerfile
    container_name: fullstack-nginx
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - frontend
      - backend
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - backend_static:/static
    networks:
      - frontend-network
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/health"]
      interval: 30s
      timeout: 5s
      retries: 3

networks:
  backend-network:
    driver: bridge
  frontend-network:
    driver: bridge

volumes:
  postgres_data:
  redis_data:
  backend_static:
```

---

## Planned Environment Variables
```bash
# .env.example

# Application
APP_NAME=fullstack-demo
ENVIRONMENT=development

# Database
DB_NAME=appdb
DB_USER=appuser
DB_PASSWORD=changeme_in_production
DB_HOST=postgres
DB_PORT=5432

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DB=0

# Django
DJANGO_SECRET_KEY=changeme_in_production
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

# Frontend
REACT_APP_API_URL=http://localhost/api
```

---

## Planned Improvements from Project 1

### Backend Dockerfile (Multi-stage)
```dockerfile
# STAGE 1: Builder
FROM python:3.12-slim AS builder
WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

# STAGE 2: Runtime
FROM python:3.12-slim
RUN useradd -m -u 1001 appuser
WORKDIR /app
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .
USER appuser
HEALTHCHECK --interval=30s CMD curl -f http://localhost:8000/health || exit 1
CMD ["gunicorn", "api.wsgi:application", "--bind", "0.0.0.0:8000"]
```

### Security Enhancements
- ✅ Non-root users in all containers
- ✅ Read-only root filesystem (where possible)
- ✅ No privileged containers
- ✅ Secrets via environment variables (not hardcoded)
- ✅ Network segmentation (backend/frontend networks)

### Health Checks
- ✅ All services have health checks
- ✅ `depends_on` uses condition: service_healthy
- ✅ Proper startup order

### Resource Management
```yaml
deploy:
  resources:
    limits:
      cpus: '0.5'
      memory: 512M
    reservations:
      cpus: '0.25'
      memory: 256M
```

---

## Planned Testing Strategy

### Local Testing
```bash
# Start all services
docker-compose up --build

# Run backend tests
docker-compose exec backend pytest

# Run frontend tests
docker-compose exec frontend npm test

# Check service health
docker-compose ps
```

### CI/CD Integration
- [ ] All Project 2 tests still pass
- [ ] Database migration tests
- [ ] Integration tests (API + DB)
- [ ] End-to-end tests (optional)

---

## Planned Commands

### Development
```bash
# Start development environment
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# View logs
docker-compose logs -f [service_name]

# Execute commands in containers
docker-compose exec backend python manage.py migrate
docker-compose exec backend python manage.py createsuperuser
docker-compose exec postgres psql -U appuser -d appdb

# Rebuild specific service
docker-compose up -d --build backend

# Stop all services
docker-compose down

# Stop and remove volumes (⚠️ deletes data!)
docker-compose down -v
```

### Production
```bash
# Start production environment
docker-compose up -d

# Scale services (if needed)
docker-compose up -d --scale backend=3

# Backup database
./scripts/backup-db.sh

# View resource usage
docker stats
```

---

## Expected Challenges & Solutions

### Challenge 1: Database Connection Timing
**Problem**: Backend starts before Postgres is ready  
**Solution**: Use `depends_on` with health checks

### Challenge 2: Data Persistence
**Problem**: Data lost on container restart  
**Solution**: Named volumes for Postgres & Redis

### Challenge 3: Network Communication
**Problem**: Services can't reach each other  
**Solution**: Custom bridge networks, service names as DNS

### Challenge 4: Environment Management
**Problem**: Different configs for dev/prod  
**Solution**: .env files + docker-compose overrides

---

## Success Criteria
```
☐ All 5 services start successfully
☐ Frontend accessible via Nginx (port 80)
☐ Backend connects to PostgreSQL
☐ Redis caching works
☐ Data persists across restarts
☐ Health checks all passing
☐ All tests pass (backend + frontend)
☐ CI/CD pipeline updated and working
☐ Documentation complete
☐ Resource usage optimized (<2GB total)
```

---

## Estimated Timeline

- **Day 1**: Docker Compose setup + PostgreSQL integration
- **Day 2**: Redis + Backend improvements (multi-stage, health checks)
- **Day 3**: Nginx setup + Testing + Documentation

**Total**: 2-3 days

---

## Skills Progression
```
Project 1: Docker basics
    ↓
Project 2: CI/CD automation
    ↓
Project 3: Multi-container orchestration ← (YOU ARE HERE)
    ↓
Project 4: Infrastructure as Code (Terraform)
```

---

## Resources & References

### To Study Before Starting
- [ ] [Docker Compose Documentation](https://docs.docker.com/compose/)
- [ ] [PostgreSQL Docker Guide](https://hub.docker.com/_/postgres)
- [ ] [Redis Docker Guide](https://hub.docker.com/_/redis)
- [ ] [Nginx Reverse Proxy Tutorial](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/)
- [ ] [Django Database Configuration](https://docs.djangoproject.com/en/5.0/ref/databases/)

### Tools to Install
- [ ] Docker Desktop (already have ✅)
- [ ] Docker Compose (included with Docker Desktop ✅)
- [ ] PostgreSQL Client: `brew install postgresql@16` (for psql commands)
- [ ] Redis CLI: `brew install redis` (for redis-cli commands)

---

## Future Enhancements (Post Project 3)

- 🔐 **Add SSL/TLS** - Let's Encrypt integration
- 📊 **Add Monitoring** - Prometheus + Grafana (Project 6 preview)
- 🔄 **Add Message Queue** - RabbitMQ or Kafka
- 🗄️ **Add Backup Strategy** - Automated database backups
- 🚀 **Add Auto-scaling** - Docker Swarm or Kubernetes prep
- 🔍 **Add Logging** - ELK Stack or Loki
- 🛡️ **Add Security Scanning** - Trivy for container scanning

---

## Notes & Ideas

### Things to Remember
- Keep it simple first, optimize later
- Test each service individually before combining
- Use health checks for all services
- Document environment variables clearly
- Commit often with clear messages

### Questions to Answer During Build
- How to handle database migrations in containers?
- Best practice for secret management?
- How to debug network issues between containers?
- When to use bind mounts vs named volumes?

---

## Author

**KODCHAMON BOONCHAN**  
DevOps Learning Journey - Stage 1 (Project 3/10)

**Current Status**: Planning Phase  
**Next Action**: Review resources, then start implementation

---

## Changelog

- **2024-XX-XX**: Initial planning document created
- **2024-XX-XX**: (Will update when starting implementation)
- **2024-XX-XX**: (Will update when completed)

---

**This is a planning document. Will be updated as project progresses.**