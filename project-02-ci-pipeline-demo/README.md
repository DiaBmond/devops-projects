# Project 2: CI/CD Pipeline with GitHub Actions

![CI Pipeline](https://github.com/DiaBmond/devops-projects/actions/workflows/project02-ci.yml/badge.svg)
![Python](https://img.shields.io/badge/python-3.12-blue)
![Node](https://img.shields.io/badge/node-20.x-green)
![Coverage](https://img.shields.io/badge/coverage-85%25-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Overview

A production-grade **Continuous Integration pipeline** demonstrating automated testing, code quality checks, and Docker builds using **GitHub Actions**.

This project builds upon [Project 1: Docker Hello App](../project-01-docker-hello-app) by adding automated workflows that run on every code push.

**Learning Path**: This is **Project 2 of 10** in the DevOps Roadmap (Stage 1: Beginner).

---

## Learning Objectives

After completing this project, you will understand:

- GitHub Actions workflow syntax and structure
- Multi-job pipelines with dependencies
- Automated testing in CI environment
- Test coverage measurement and reporting
- Build automation strategies
- Fail-fast patterns (test → build)
- Artifact management
- Caching strategies for faster builds
- CI/CD best practices


---

## Features

### Automated Testing
- **Backend**: pytest with pytest-django and coverage
- **Frontend**: Jest with React Testing Library
- **Coverage Reports**: Automatically generated and uploaded

### Docker Automation
- Automated image builds after tests pass
- Multi-stage Dockerfile validation
- Tagged with commit SHA for traceability

### Visibility
- Real-time CI status badge
- Detailed logs for debugging
- Downloadable test coverage reports
- Job dependency visualization

---

## Quick Start

### Prerequisites

- Git and GitHub account
- Docker Desktop (for local testing)
- Python 3.12+ (for local dev)
- Node.js 20+ (for local dev)

### 1. Clone and Setup

```bash
# Clone repository
git clone https://github.com/DiaBmond/devops-projects.git
cd devops-projects/project-02-ci-pipeline-demo

# Run with Docker Compose
docker-compose up --build
```

### 2. Trigger CI Pipeline

```bash
# Make a change
echo "# Test" >> README.md

# Commit and push
git add .
git commit -m "test: trigger CI pipeline"
git push origin main
```

### 3. Monitor Pipeline

1. Go to **GitHub Actions** tab in your repository
2. Click on the latest workflow run
3. Watch jobs execute in real-time
4. Download test coverage artifacts

---

## Running Tests Locally

### Backend Tests

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Run all tests
pytest

# Run with coverage
pytest --cov

# Run specific test file
pytest tests/test_api.py -v

# Generate HTML coverage report
pytest --cov --cov-report=html
open htmlcov/index.html
```

### Frontend Tests

```bash
cd frontend

# Install dependencies
npm install

# Run tests
npm test

# Run with coverage
npm test -- --coverage

# Run in watch mode (development)
npm test -- --watch

# Run specific test file
npm test -- App.test.tsx

# View coverage report
open coverage/lcov-report/index.html  # macOS
# start coverage/lcov-report/index.html  # Windows
```

---

## CI/CD Workflow Details

### Workflow File: `.github/workflows/project02-ci.yml`

### Pipeline Stages Explained

#### Stage 1: Test Backend (14 seconds)
1. **Checkout code** - Get latest commit
2. **Setup Python** - Install Python 3.12
3. **Install dependencies** - pip install requirements
4. **Run pytest** - Execute all backend tests
5. **Generate coverage** - Create HTML report
6. **Upload artifact** - Store coverage report

#### Stage 2: Test Frontend (21 seconds)
1. **Checkout code** - Get latest commit
2. **Setup Node.js** - Install Node.js 20
3. **Restore cache** - Load cached npm packages
4. **Install dependencies** - npm ci
5. **Run Jest** - Execute all frontend tests
6. **Generate coverage** - Create HTML report
7. **Upload artifact** - Store coverage report

#### Stage 3: Build Docker Images (40 seconds)
1. **Wait for tests** - Only runs if both tests pass
2. **Checkout code** - Get latest commit
3. **Build backend** - docker build with SHA tag
4. **Build frontend** - docker build with SHA tag

---

## What You Learned

### CI/CD Concepts

- **Continuous Integration**: Automatically test every code change
- **Pipeline as Code**: Workflows defined in YAML
- **Job Dependencies**: Using `needs` to create workflow stages
- **Fail-Fast**: Stop pipeline early if tests fail
- **Artifacts**: Storing and downloading build outputs

### GitHub Actions Specifics

- **Workflow triggers**: `on: push`, `on: pull_request`
- **Job matrix**: Running tests in parallel
- **Actions marketplace**: Reusing community actions
- **Caching**: Speeding up builds with `cache`
- **Secrets management**: Secure credential handling

### Testing Best Practices

- **Backend Testing**: pytest for Python/Django
- **Frontend Testing**: Jest + React Testing Library
- **Coverage Metrics**: Measuring code coverage
- **Test Isolation**: Tests don't depend on each other
- **Assertions**: Checking expected behavior

### DevOps Principles

**Automation**: Manual testing → Automated testing  
**Feedback Loop**: Fast failure detection  
**Reproducibility**: Same tests run locally and in CI  
**Visibility**: Status badges and logs  
**Quality Gates**: Tests must pass before build  

---

## Viewing Test Coverage Reports

### Option 1: Download from GitHub

1. Go to **GitHub Actions** tab
2. Click on any workflow run
3. Scroll to **Artifacts** section
4. Download:
   - `backend-coverage.zip` 
   - `frontend-coverage.zip`
5. Extract and open `index.html` in browser

### Option 2: Generate Locally

```bash
# Backend
cd backend
pytest --cov --cov-report=html
open htmlcov/index.html

# Frontend
cd frontend
npm test -- --coverage
open coverage/lcov-report/index.html
```

---

## Troubleshooting

### Pipeline Fails: Backend Tests

**Error:**
```
ModuleNotFoundError: No module named 'pytest'
```

**Solution:**
```bash
# Add pytest to requirements-dev.txt
echo "pytest" >> backend/requirements-dev.txt
echo "pytest-django" >> backend/requirements-dev.txt
echo "pytest-cov" >> backend/requirements-dev.txt
git add backend/requirements-dev.txt
git commit -m "fix: add test dependencies"
git push
```

---

### Pipeline Fails: Frontend Tests

**Error:**
```
npm ERR! Cannot find module 'jest'
```

**Solution:**
```bash
cd frontend
npm install --save-dev jest @testing-library/react @testing-library/jest-dom
git add package.json package-lock.json
git commit -m "fix: add jest dependencies"
git push
```

---

### Build Fails After Tests Pass

**Check:**
1. Dockerfile syntax errors
2. Missing files referenced in Dockerfile
3. Docker build context issues

```bash
# Test Docker build locally
cd backend
docker build -t test-backend .

cd ../frontend
docker build -t test-frontend .
```

---

## Next Project

**[Project 3: Docker Compose Fullstack](../project-03-docker-compose-fullstack)**

You'll learn:
- Multi-container orchestration
- Service networking
- Volumes and data persistence
- Environment-specific configs
- Database integration (PostgreSQL, Redis)

---

## Resources & References

### Official Documentation
- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [pytest Documentation](https://docs.pytest.org/)
- [Jest Documentation](https://jestjs.io/)
- [React Testing Library](https://testing-library.com/react)

### Best Practices Guides
- [GitHub Actions Best Practices](https://docs.github.com/en/actions/learn-github-actions/best-practices-for-github-actions)
- [Effective pytest](https://pragprog.com/titles/bopytest/python-testing-with-pytest/)
- [Testing React Applications](https://kentcdodds.com/blog/common-mistakes-with-react-testing-library)

### Related Articles
- [CI/CD Pipeline Best Practices](https://about.gitlab.com/topics/ci-cd/best-practices/)
- [Test Coverage vs Code Quality](https://martinfowler.com/bliki/TestCoverage.html)

---

## Author

**KODCHAMON BOONCHAN**  
DevOps Learning Journey - Project 2/10 (Stage 1: Beginner)  
[GitHub Profile](https://github.com/DiaBmond) | [All Projects](https://github.com/DiaBmond/devops-projects)

---

## License

MIT License - Feel free to use this project for learning purposes.

---

## Achievement Unlocked

**CI/CD Fundamentals Mastered**
- Built automated test pipeline
- Integrated GitHub Actions
- Measured test coverage
- Implemented fail-fast pattern
- Automated Docker builds

**Ready for:** Project 3 - Docker Compose Fullstack 