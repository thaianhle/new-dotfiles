#!/bin/bash
# File: boot_instance.sh

# Variables
INSTANCE_NAME="centos-vm"
REGION="asia-southeast1-b"
MACHINE_TYPE="n2d-highcpu-8"
IMAGE_FAMILY="centos-stream-9"
IMAGE_PROJECT="centos-cloud"
ZONE="asia-southeast1-b"

echo "Creating GCP instance: $INSTANCE_NAME"

gcloud compute instances create $INSTANCE_NAME \
  --zone=$ZONE \
  --machine-type=$MACHINE_TYPE \
  --image-family=$IMAGE_FAMILY \
  --image-project=$IMAGE_PROJECT \
  --provisioning-model=SPOT \
  --instance-termination-action=DELETE \
  --description="Spot VM for development with auto-delete boot disk" \
  --no-boot-disk-auto-delete

echo "Instance $INSTANCE_NAME created successfully!"