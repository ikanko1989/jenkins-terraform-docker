
#  Project: jenkins-terraform-docker-nginx-project

## 🎯 Objectives

This project demonstrates how to use **Jenkins pipeline** to automate the provisioning of a **Dockerized NGINX container** using **Terraform**.  
The Jenkins pipeline pulls Terraform configuration from this GitHub repository, initializes Terraform, and deploys an NGINX Docker container on the Jenkins host.  

📦 Project Overview  
  This repository contains:  
  ✅ Terraform configuration file (main.tf) to define a Docker container running NGINX  
  ✅ Jenkins pipeline (Jenkinsfile) that:  
  - Clones this repository  
  - Runs Terraform to deploy the NGINX container  
  - Verifies that the container is running  


## ⚙️ How It Works

1. **Jenkins Pipeline**  
   Jenkins pulls the project from GitHub and executes the Jenkinsfile  

2. **Terraform Execution**  
   Inside the pipeline, Terraform is initialized and applied from the terraform/main.tf file  

3. **Docker Provider**  
   Terraform uses the kreuzwerker/docker provider to interact with the local Docker daemon  

4. **NGINX Deployment**  
   Terraform pulls the nginx:latest image and starts an NGINX container named nginx  

5. **Port Mapping & Verification**  
   The container’s port 80 is mapped to host port 8081, making the service accessible externally.  
   Jenkins runs docker ps to confirm that the NGINX container is running successfully.  

7. **Live App Access**  
  The NGINX welcome page can be accessed at:
 __http://localhost:8081__

