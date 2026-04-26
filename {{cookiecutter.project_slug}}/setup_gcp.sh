#!/bin/bash
# ============================================================
# GCP Project Setup Script
# Author: {{ cookiecutter.author_name }}
# Project: {{ cookiecutter.project_name }}
# ============================================================

set -e  # exit on any error

PROJECT_ID="{{ cookiecutter.gcp_project_id }}"
BUCKET_NAME="{{ cookiecutter.gcs_bucket_name }}"
BQ_DATASET="{{ cookiecutter.bq_dataset_name }}"
REGION="{{ cookiecutter.gcp_region }}"

echo "============================================"
echo "Setting up GCP for: $PROJECT_ID"
echo "============================================"

# Step 1 — Set project
echo "→ Setting GCP project..."
gcloud config set project $PROJECT_ID
gcloud auth application-default set-quota-project $PROJECT_ID

# Step 2 — Enable APIs
echo "→ Enabling APIs..."
gcloud services enable bigquery.googleapis.com
gcloud services enable storage.googleapis.com

# Step 3 — Create GCS bucket
echo "→ Creating GCS bucket..."
gcloud storage buckets create gs://$BUCKET_NAME \
    --project=$PROJECT_ID \
    --location=$REGION

# Create subfolders
gcloud storage cp /dev/null gs://$BUCKET_NAME/raw/.gitkeep
gcloud storage cp /dev/null gs://$BUCKET_NAME/processed/.gitkeep

echo " GCS bucket created: gs://$BUCKET_NAME"

# Step 4 — Create BigQuery dataset
echo "→ Creating BigQuery dataset..."
bq --location=US mk --dataset $PROJECT_ID:$BQ_DATASET

echo " BigQuery dataset created: $BQ_DATASET"

# Step 5 — Authenticate Python
echo "→ Authenticating Python..."
gcloud auth application-default login

echo ""
echo "============================================"
echo "   GCP Setup Complete!"
echo "   Project:    $PROJECT_ID"
echo "   Bucket:     gs://$BUCKET_NAME"
echo "   BQ Dataset: $BQ_DATASET"
echo "============================================"
