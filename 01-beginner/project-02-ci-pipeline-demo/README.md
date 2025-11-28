# Project 2: CI Pipeline with GitHub Actions 

![CI Pipeline](https://github.com/DiaBmond/devops-projects/actions/workflows/project02-ci.yml/badge.svg)
![Python](https://img.shields.io/badge/python-3.12-blue)
![Node](https://img.shields.io/badge/node-20.x-green)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Overview

Automated CI/CD pipeline demonstrating continuous integration, automated testing, and Docker builds using GitHub Actions.

This project builds upon [Project 1](../project-01-docker-hello-app) by adding automated testing and deployment workflows.

---

## Features

- **Automated Testing**: Backend (pytest) and Frontend (Jest) tests run on every push
- **Docker Builds**: Automated image building after tests pass
- **Fast Pipeline**: Complete CI cycle in ~1 minute
- **Job Dependencies**: Build only runs if all tests pass (fail-fast)
- **Caching**: npm packages cached for faster builds
- **Coverage Reports**: Test coverage artifacts uploaded on every run
- **Status Badge**: Real-time CI status visible in README

---

## Skills Learned

### CI/CD Concepts
- GitHub Actions fundamentals (workflows, jobs, steps)
- Workflow triggers (push, pull_request)
- Job dependencies with `needs`
- Automated testing in CI environment
- Build automation
- Artifact management

### Testing
- Backend: pytest with pytest-django
- Frontend: Jest with React Testing Library
- Test coverage measurement and reporting
- Writing unit tests for APIs and components

### DevOps Best Practices
- Fail-fast pipelines (test before build)
- Caching strategies for faster builds
- Status badges for visibility
- Clean separation of test and build stages
- Deterministic builds with npm ci

### YAML & Configuration
- GitHub Actions workflow syntax
- Multi-job workflows
- Environment setup (Python, Node.js)
- Action marketplace usage

---

## How to Run Tests Locally

### Backend Tests
```bash
# Navigate to backend
cd backend

# Install dependencies
pip install -r requirements.txt -r requirements-dev.txt

# Run tests
pytest

# Run with coverage
pytest --cov

# Generate HTML coverage report
pytest --cov --cov-report=html
open htmlcov/index.html  # View detailed report
```

### Frontend Tests
```bash
# Navigate to frontend
cd frontend

# Install dependencies
npm install

# Run tests
npm test

# Run with coverage
npm test -- --coverage

# View coverage report
open coverage/lcov-report/index.html
```

---

## CI/CD Pipeline

This project uses **GitHub Actions** for continuous integration.

### Workflow Jobs

#### Job 1: Test Backend
- Setup Python 3.12
- Install dependencies (requirements.txt + requirements-dev.txt)
- Run pytest with coverage
- Upload coverage report as artifact

#### Job 2: Test Frontend
- Setup Node.js 20
- Install dependencies (npm ci with caching)
- Run Jest tests with coverage
- Upload coverage report as artifact

#### Job 3: Build Docker Images
- Waits for both test jobs to pass (`needs`)
- Build backend Docker image
- Build frontend Docker image
- Tag with commit SHA

### What Gets Tested

**Backend:**
- API endpoint responses (status codes, JSON structure)
- Health check endpoint
- Django application initialization

**Frontend:**
- Component rendering
- Text content display
- Application structure

**Infrastructure:**
- Docker image builds (backend + frontend)
- Multi-stage Dockerfile validation

### Pipeline Performance

- **Total Duration**: ~1 minute 6 seconds ⚡
- **Test Backend**: 14 seconds
- **Test Frontend**: 21 seconds
- **Build Images**: 40 seconds

---

## Running the Application Locally

### With Docker Compose
```bash
# Start all services
docker-compose up --build

# Access services
Frontend: http://localhost:3000
Backend:  http://localhost:8000
```

### Without Docker

**Backend:**
```bash
cd backend
pip install -r requirements.txt
python manage.py runserver
```

**Frontend:**
```bash
cd frontend
npm install
npm start
```

---

## Viewing Test Coverage Reports

After CI runs, you can download coverage reports:

1. Go to **GitHub Actions** tab
2. Click on any workflow run
3. Scroll to **Artifacts** section
4. Download `backend-coverage` or `frontend-coverage`
5. Extract and open `index.html`

---

## Troubleshooting

### CI Pipeline Fails

**Backend test fails:**
```bash
# Check if tests pass locally first
cd backend
pytest -v

# Common issues:
# - Missing dependencies in requirements-dev.txt
# - Django settings not configured for tests
# - Import errors (check PYTHONPATH)
```

---

## What's Next?

### Potential Enhancements

- 🔄 **Add linting**: ESLint for frontend, Black/Flake8 for backend
- 🔐 **Security scanning**: Trivy or Snyk for vulnerability detection
- 📊 **Code quality**: SonarQube or CodeClimate integration
- 🚀 **Deploy stage**: Auto-deploy to staging on success
- 🐳 **Push images**: Upload to Docker Hub or GitHub Container Registry
- 📧 **Notifications**: Slack/Discord alerts on failures
- 🔀 **Branch protection**: Require CI to pass before merge
- 🎯 **Matrix testing**: Test multiple Python/Node versions

### Related Projects

- **[Project 1: Docker Hello App](../project-01-docker-hello-app)** - Foundation
- **[Project 3: Docker Compose Fullstack](../project-03-docker-compose-fullstack)** - Next (coming soon)

---

## Resources & References

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [pytest Documentation](https://docs.pytest.org/)
- [React Testing Library](https://testing-library.com/react)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

## Author

**KODCHAMON BOONCHAN**  
DevOps Learning Journey - Stage 2/10  
[GitHub Profile](https://github.com/DiaBmond) | [Project Repository](https://github.com/DiaBmond/devops-projects)

---

## License

MIT License - Feel free to use this project for learning purposes.

---