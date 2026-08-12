#!/bin/bash
set -Eeuo pipefail

# ============================================================
# VinceOps Cloud — Month 2B
# Private Web Tier Bootstrap
#
# Portfolio-safe reconstruction of the final validated
# Launch Template User Data used during Month 2B.
#
# Sensitive/resource-specific identifiers have been sanitised.
# ============================================================

exec > >(tee -a /var/log/vinceops-web-bootstrap.log) 2>&1

trap 'echo "[ERROR] VinceOps bootstrap failed at line ${LINENO}"' ERR

echo "===== VinceOps web bootstrap started ====="

# ------------------------------------------------------------
# 1. Assign a unique hostname to each Auto Scaling instance
# ------------------------------------------------------------

PRIVATE_IP=$(hostname -I | awk '{print $1}')
SAFE_IP=$(echo "$PRIVATE_IP" | tr '.' '-')
HOSTNAME_VALUE="web-${SAFE_IP}"

hostnamectl set-hostname "$HOSTNAME_VALUE"

echo "Hostname configured: ${HOSTNAME_VALUE}"

# ------------------------------------------------------------
# 2. Install application and EFS dependencies
# ------------------------------------------------------------
#
# Amazon Linux 2023 ships with curl-minimal.
# Installing the full curl package caused a package conflict
# during an earlier Launch Template iteration, so the final
# bootstrap avoids replacing it unnecessarily.
# ------------------------------------------------------------

dnf install -y nginx amazon-efs-utils

if ! command -v curl >/dev/null 2>&1; then
    dnf install -y curl-minimal
fi

# ------------------------------------------------------------
# 3. Configure shared Amazon EFS storage
# ------------------------------------------------------------
#
# Actual resource IDs used in the deployed environment have
# been sanitised before publication.
# ------------------------------------------------------------

EFS_ID="fs-REDACTED"
ACCESS_POINT_ID="fsap-REDACTED"
MOUNT_POINT="/var/www/html"

mkdir -p "$MOUNT_POINT"

# ------------------------------------------------------------
# 4. Configure persistent EFS mounting
# ------------------------------------------------------------

FSTAB_LINE="${EFS_ID}:/ ${MOUNT_POINT} efs _netdev,noresvport,tls,accesspoint=${ACCESS_POINT_ID},nofail 0 0"

if ! grep -Fq "${EFS_ID}:/" /etc/fstab; then
    echo "$FSTAB_LINE" >> /etc/fstab
fi

# ------------------------------------------------------------
# 5. Mount EFS with retry logic
# ------------------------------------------------------------

if ! mountpoint -q "$MOUNT_POINT"; then

    for attempt in {1..12}; do

        echo "EFS mount attempt ${attempt}..."

        if mount -t efs \
            -o tls,accesspoint="${ACCESS_POINT_ID}" \
            "${EFS_ID}:/" \
            "$MOUNT_POINT"; then

            echo "EFS mounted successfully."
            break
        fi

        sleep 10
    done
fi

# Fail bootstrap if the shared file system is unavailable.

mountpoint -q "$MOUNT_POINT"

echo "EFS mount verified."

# ------------------------------------------------------------
# 6. Configure Nginx
# ------------------------------------------------------------

cat > /etc/nginx/nginx.conf <<EOF
user nginx;
worker_processes auto;

error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    sendfile on;
    keepalive_timeout 65;

    server {
        listen 80 default_server;
        server_name _;

        root /var/www/html;
        index index.html;

        location / {
            try_files \$uri \$uri/ =404;
        }

        location = /instance {
            default_type text/plain;
            return 200 "served-by: ${HOSTNAME_VALUE}\n";
        }
    }
}
EOF

# ------------------------------------------------------------
# 7. Validate and start Nginx
# ------------------------------------------------------------

nginx -t

systemctl enable --now nginx
systemctl is-active --quiet nginx

echo "Nginx is active."

# ------------------------------------------------------------
# 8. Verify application content locally
# ------------------------------------------------------------

curl --fail --silent --show-error http://localhost/ >/dev/null
curl --fail --silent --show-error http://localhost/health.html >/dev/null

echo "Application health check passed."

# ------------------------------------------------------------
# 9. Retrieve Datadog API key securely from AWS
# ------------------------------------------------------------
#
# No Datadog credential is embedded in this script.
# The EC2 instance profile authorises retrieval of the
# SecureString parameter from AWS Systems Manager Parameter
# Store.
# ------------------------------------------------------------

AWS_REGION="us-east-1"
DD_SITE="datadoghq.com"
DD_PARAMETER="/vinceops/m2b/datadog/api-key"

# Confirm the instance has usable IAM credentials.

aws sts get-caller-identity >/dev/null

DD_API_KEY="$(
    aws ssm get-parameter \
        --name "$DD_PARAMETER" \
        --with-decryption \
        --region "$AWS_REGION" \
        --query 'Parameter.Value' \
        --output text
)"

if [[ -z "$DD_API_KEY" ]]; then
    echo "[ERROR] Datadog API key retrieval returned an empty value."
    exit 1
fi

echo "Datadog credential retrieved securely from Parameter Store."

# ------------------------------------------------------------
# 10. Install Datadog Agent
# ------------------------------------------------------------

DATADOG_INSTALLER="/tmp/install_datadog.sh"

curl -fsSL \
    --max-time 30 \
    https://install.datadoghq.com/scripts/install_script_agent7.sh \
    -o "$DATADOG_INSTALLER"

DD_API_KEY="$DD_API_KEY" \
DD_SITE="$DD_SITE" \
bash "$DATADOG_INSTALLER"

# Remove secret from the shell environment immediately.

unset DD_API_KEY
rm -f "$DATADOG_INSTALLER"

# ------------------------------------------------------------
# 11. Enable and verify Datadog
# ------------------------------------------------------------

systemctl enable --now datadog-agent
systemctl is-active --quiet datadog-agent

echo "Datadog Agent is active."

# ------------------------------------------------------------
# 12. Final bootstrap verification
# ------------------------------------------------------------

echo "Hostname: $(hostname)"
echo "Nginx: $(systemctl is-active nginx)"
echo "EFS mount: $(findmnt -n -o TARGET "$MOUNT_POINT")"
echo "Datadog Agent: $(systemctl is-active datadog-agent)"

echo "===== VinceOps web bootstrap completed successfully ====="
