# Containerized Full-Stack Movie Application

## Overview

This project demonstrates the containerization and cloud deployment of a full-stack movie application using Docker, AWS EC2, Amazon ECR, MongoDB, React, and Spring Boot.

The application was packaged into containers, deployed on an AWS Ubuntu server, and validated through production testing.

---

# System Architecture

```
                         USER
                          |
                          |
                    Web Browser
                          |
                          |
                     Internet
                          |
                          |
              AWS EC2 Ubuntu Server
              Public Application Host
                          |
                          |
                  Docker Engine
                          |
        ------------------------------------
        |                |                 |
        |                |                 |
        v                v                 v

+----------------+ +----------------+ +----------------+
|   Frontend     | |    Backend     | |    MongoDB     |
| React          | | Spring Boot    | |   Database     |
| Container      | | API Container  | |  Container     |
+----------------+ +----------------+ +----------------+

        |                |
        |                |
        +----------------+
              REST API
          Application Data Flow


                DEPLOYMENT PIPELINE

Developer
    |
    |
GitHub Repository
    |
    |
Docker Build Process
    |
    |
Docker Images
    |
    |
Amazon ECR
    |
    |
EC2 pulls images
    |
    |
Production Containers
```

---

# Technology Stack

## Application Layer

- React frontend
- Spring Boot backend
- MongoDB database

## Container Layer

- Docker
- Docker Images
- Docker Containers

## Cloud Layer

- AWS EC2 Ubuntu
- Amazon Elastic Container Registry (ECR)

## Development Tools

- GitHub
- Linux Ubuntu
- Git

---

# Container Structure

## Frontend Container

Responsibilities:

- Serves React application
- Provides user interface
- Communicates with backend API

---

## Backend Container

Responsibilities:

- Runs Spring Boot application
- Provides REST API endpoints
- Handles application logic

---

## MongoDB Container

Responsibilities:

- Stores application data
- Provides database services to backend

---

# Deployment Workflow

The deployment process followed these stages:

1. Source code stored in GitHub repository

2. Dockerfiles created for frontend and backend services

3. Docker images built locally

4. Images pushed to Amazon ECR

5. AWS EC2 Ubuntu server configured

6. Containers deployed using Docker

7. Application tested through browser access

---

# Production Verification

The deployment was verified through:

- EC2 instance availability
- Running Docker containers
- Backend API health checks
- MongoDB connectivity
- Frontend accessibility
- Movie trailer playback

Evidence screenshots are available:

```
docs/screenshots/
```

---

# Skills Demonstrated

- Docker containerization
- Cloud deployment
- AWS EC2 administration
- Amazon ECR image management
- Linux server management
- Application troubleshooting
- Container networking
- Full-stack deployment workflow

---

# Project Result

A complete full-stack application was successfully transformed from source code into a cloud-hosted containerized environment.

The project demonstrates the complete journey:

```
Code
 |
Containerization
 |
Cloud Deployment
 |
Production Validation
```
