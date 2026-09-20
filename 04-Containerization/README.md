# Containerized Full-Stack Movie Application

## Overview

This project demonstrates the containerization and cloud deployment of a full-stack movie application using Docker, AWS EC2, Amazon ECR, MongoDB, React, and Spring Boot.

The application was packaged into containers and deployed on an AWS EC2 Ubuntu server, with production verification completed after deployment.

---

# Architecture
User
|
Internet
|
AWS EC2 Instance
|
Docker Environment
|
| | |
Frontend Backend MongoDB
React Spring Boot Database
Container Container Container

---

# Technologies Used

## Application

- React
- Spring Boot
- MongoDB

## DevOps

- Docker
- Docker Images
- Docker Containers
- Amazon EC2
- Amazon Elastic Container Registry (ECR)
- Linux Ubuntu

---

# Containerization Process

## Backend

The Spring Boot backend was containerized using Docker.

Completed:

- Created backend Dockerfile
- Built backend image
- Started backend container
- Connected backend service to MongoDB
- Verified API responses

---

## Frontend

The React frontend was containerized for production deployment.

Completed:

- Created frontend Dockerfile
- Built production image
- Connected frontend to backend API
- Verified application accessibility

---

# Cloud Deployment

The application was deployed on AWS EC2.

Deployment workflow:

1. Launch EC2 Ubuntu instance
2. Install Docker environment
3. Build application images
4. Push images to Amazon ECR
5. Run production containers
6. Verify application functionality

---

# Production Verification

The deployment was verified through:

- Running Docker containers
- Backend API health checks
- MongoDB connection
- Frontend accessibility
- Movie trailer functionality

---

# Deployment Evidence

Screenshots are available here:


docs/screenshots/


Evidence includes:

- EC2 instance running
- Docker containers running
- Backend API verification
- Frontend production access
- ECR image upload
- MongoDB connection
- Final production test

---

# Key Skills Demonstrated

- Containerizing full-stack applications
- Docker image management
- Cloud deployment
- Linux server administration
- Application networking
- Database connectivity troubleshooting
- Production environment verification

---

# Final Result

A complete full-stack application was successfully containerized and deployed in a production-style AWS env
