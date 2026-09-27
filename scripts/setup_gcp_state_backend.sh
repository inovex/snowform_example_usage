#!/usr/bin/env bash
# One-time setup of the GCS bucket that stores the OpenTofu state of this repo,
# and of keyless access to it from GitHub Actions (Workload Identity Federation).
#
# Run it in Google Cloud Shell (already authenticated) or anywhere with gcloud
# logged in as a project owner. See "Terraform State Backend (GCS)" in README.md.
#
# Already executed on 2026-09-27 for the values below. Re-running it is safe:
# the create commands fail with "already exists" and change nothing.
set -euo pipefail

PROJECT_ID="quickstart-1592892564690"
PROJECT_NUMBER="294471397577"
REGION="europe-west3" # Frankfurt
BUCKET="${PROJECT_ID}-snowform-tfstate"
REPO="inovex/snowform_example_usage"
SA_NAME="snowform-tfstate"
SA="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"
POOL="github"
PROVIDER="snowform-example-usage"

gcloud config set project "$PROJECT_ID"
gcloud services enable storage.googleapis.com iam.googleapis.com iamcredentials.googleapis.com sts.googleapis.com

# Private, versioned bucket (versioning lets you roll back a broken state)
gcloud storage buckets create "gs://${BUCKET}" \
  --location="$REGION" --uniform-bucket-level-access --public-access-prevention
gcloud storage buckets update "gs://${BUCKET}" --versioning

# Service account with access to this bucket only
gcloud iam service-accounts create "$SA_NAME" \
  --display-name="SnowForm Terraform state (GitHub Actions)"
gcloud storage buckets add-iam-policy-binding "gs://${BUCKET}" \
  --member="serviceAccount:${SA}" --role=roles/storage.objectAdmin

# Let GitHub Actions from this one repository act as that service account (no keys)
gcloud iam workload-identity-pools create "$POOL" \
  --location=global --display-name="GitHub Actions"
gcloud iam workload-identity-pools providers create-oidc "$PROVIDER" \
  --location=global --workload-identity-pool="$POOL" \
  --issuer-uri=https://token.actions.githubusercontent.com \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository" \
  --attribute-condition="assertion.repository=='${REPO}'"
gcloud iam service-accounts add-iam-policy-binding "$SA" \
  --role=roles/iam.workloadIdentityUser \
  --member="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL}/attribute.repository/${REPO}"

echo "BUCKET=${BUCKET}"
echo "SERVICE_ACCOUNT=${SA}"
echo "WIF_PROVIDER=projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${POOL}/providers/${PROVIDER}"
