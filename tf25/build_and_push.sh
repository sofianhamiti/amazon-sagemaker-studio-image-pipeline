#!/usr/bin/env bash

image_name=$1
tag=$2

fullname="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com/${image_name}:${tag}"

# Get the login command from ECR and execute it directly
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com

# If the repository doesn't exist in ECR, create it.
aws ecr describe-repositories --repository-names ${image_name} || aws ecr create-repository --repository-name ${image_name}

# Build the docker image locally and then push it to ECR with the full name.
echo "BUILDING IMAGE WITH NAME ${image_name} AND TAG ${tag}"
cd docker
docker build --no-cache -t ${image_name} -f Dockerfile .
docker tag ${image_name} ${fullname}

echo "PUSHING IMAGE TO ECR ECR ${fullname}"
docker push ${fullname}