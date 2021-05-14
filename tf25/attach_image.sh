#!/usr/bin/env bash

image_name=$1
tag=$2

image_uri="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${image_name}:${tag}"
cd docker

# Create Image version for Studio
aws sagemaker create-image-version \
  --image-name ${IMAGE_NAME} \
  --base-image ${image_uri}

# Create AppImageConfig for this image
aws sagemaker delete-app-image-config \
  --app-image-config-name tf25-config

aws sagemaker create-app-image-config \
  --cli-input-json file://app-image-config-input.json

# Update the Domain, providing the Image and AppImageConfig
aws sagemaker update-domain \
  --domain-id ${DOMAIN_ID} \
  --cli-input-json file://update-domain-input.json