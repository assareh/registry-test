#! /bin/bash
################################
# Requirements: curl, jq
################################

# NOTE: ensure TFC token is present as TOKEN env variable
# NOTE: ensure TFC org is provided below 

export TFE_TOKEN=$TOKEN
export TFE_ORG="hashidemos"
export TFE_ADDR="https://app.terraform.io/api/v2"

# Package the module
echo "Packaging the module..."
cd terraform-aws-test
tar zcvf test_module.tar.gz *
mv test_module.tar.gz ../.
cd ..

#DELETE
echo "Deleting the module..."
curl -w "%{http_code}" --silent \
--header "Authorization: Bearer ${TFE_TOKEN}" \
--header "Content-Type: application/vnd.api+json" \
--request DELETE \
"${TFE_ADDR}/organizations/${TFE_ORG}/registry-modules/private/${TFE_ORG}/test/aws" | jq

# CREATE
echo "Creating the module..."
curl -w "%{http_code}" --silent \
--header "Authorization: Bearer ${TFE_TOKEN}" \
--header "Content-Type: application/vnd.api+json" \
--request POST \
--data @test_module.json \
"${TFE_ADDR}/organizations/${TFE_ORG}/registry-modules" | jq

# CREATE VERSION
echo "Creating the module version..."
UPLOAD_URL="$(curl --silent \
  --header "Authorization: Bearer ${TFE_TOKEN}" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @test_module_version.json \
  "${TFE_ADDR}/organizations/${TFE_ORG}/registry-modules/private/${TFE_ORG}/test/aws/versions" | jq -r '.data.links.upload')"

# UPLOAD THE MODULE VERSION
echo "Uploading the module version..."
curl -w "%{http_code}" \
--header "Authorization: Bearer ${TFE_TOKEN}" \
--header "Content-Type: application/octet-stream" \
--request PUT \
--data-binary @test_module.tar.gz \
"${UPLOAD_URL}" | jq
