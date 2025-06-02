#!/bin/bash
echo "### terraform init -backend=false ###"
terraform init -backend=false
echo "### terraform validate ###"
terraform validate
echo "### terraform fmt -check -recursive ###"
terraform fmt -check -recursive
