#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
	echo "Usage: $0 <volume_name>"
	exit 1
fi

# Check if Docker is installed
if ! command -v docker &>/dev/null; then
	echo "Docker is not installed. Please install Docker and try again."
	exit 1
fi

# Variables
VOLUME_NAME="$1"
BACKUP_DIR="$PWD/$1/backup"

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

BACKUP_FILENAME="backup_${VOLUME_NAME}_${TIMESTAMP}.tar.gz"

# Create the backup directory if it doesn't exist
mkdir -p "${BACKUP_DIR}"

# Use Docker to run a temporary container with the volume attached
# The container will create a compressed archive of the volume's contents
docker run --rm \
	-v "${VOLUME_NAME}:/volume_data" \
	-v "${BACKUP_DIR}:/backup" \
	busybox tar -czf "/backup/${BACKUP_FILENAME}" -C "/volume_data" .

if [ $? -eq 0 ]; then
	echo "Backup of ${VOLUME_NAME} created: ${BACKUP_DIR}/${BACKUP_FILENAME}"
else
	echo "Backup failed."
fi
