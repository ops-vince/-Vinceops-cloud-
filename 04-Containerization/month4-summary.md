feat: month 4 - Docker, ECR, EKS via Terraform, Trivy pipeline scanning

Containerises application and provisions Kubernetes cluster on AWS EKS
using Terraform. Horizontal Pod Autoscaler configured. Trivy CVE
scanning integrated into CI/CD - critical vulnerabilities block deploy.
