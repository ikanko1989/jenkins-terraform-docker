
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


## ⚙️ Prerequisites  ##
Make sure the following are installed on your Jenkins server (master):  
✅ Jenkins (with pipeline plugin)  
✅ Terraform  
✅ Docker   
✅ Git  


* __Check docker version after installing:__  
```yaml
root@jenkins-server ~ via v17.0.13 ✖ docker --version

Docker version 28.3.3, build 980b856
```

* __Check Terraform version after installing:__  
```yaml
root@jenkins-server ~ via v17.0.13 ➜  terraform -version
Terraform v1.13.0
on linux_amd64
```


✅ GitHub holds Terraform configuration file (main.tf) to define a Docker container running NGINX:   
### `main.tf`  
```yaml
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

# Pull NGINX Docker image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Run NGINX container
resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.name  
  ports {
    internal = 80
    external = 8081
  }
}
```

✅ Jenkins pipeline: 
```yaml
pipeline {
    agent any

    environment {
        TERRAFORM_DIR = 'terraform'
        CONTAINER_NAME = 'nginx'
        HOST_PORT = '8081'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/ikanko1989/jenkins-terraform-docker.git', branch: 'main'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Verify Container') {
            steps {
                sh "docker ps | grep ${CONTAINER_NAME}"
                echo "NGINX should be running on port ${HOST_PORT}"
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        failure {
            echo 'Pipeline failed, check logs.'
        }
    }
}
```


✅ __Checking created folder/state after pipeline was successfully completed:__     
```yaml
root@jenkins-server java/terraform on main via 💠 default ➜  pwd

/var/lib/jenkins/workspace/java/terraform  


root@jenkins-server java/terraform on main via 💠 default ➜  terraform state list

docker_container.nginx

docker_image.nginx

 
root@jenkins-server java/terraform on main via 💠 default ➜  cat main.tf

terraform {

  required_providers {

    docker = {

      source  = "kreuzwerker/docker"

      version = "~> 3.0.1"

    }

  }

}
```



✅ __NGINX container is up and running and accessed on port 8081:__  
```yaml
root@jenkins-server ~/.terraform.d ➜  docker ps -a

CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                  NAMES

93102bc6f3de   nginx:latest   "/docker-entrypoint.…"   24 seconds ago   Up 24 seconds   0.0.0.0:8081->80/tcp   nginx
```

```yaml
root@jenkins-server ~/.terraform.d ✖ curl http://localhost:8081

<!DOCTYPE html>

<html>

<head>

<title>Welcome to nginx!</title>

<style>

html { color-scheme: light dark; }

body { width: 35em; margin: 0 auto;

font-family: Tahoma, Verdana, Arial, sans-serif; }

</style>

</head>

<body>

<h1>Welcome to nginx!</h1>

<p>If you see this page, the nginx web server is successfully installed and

working. Further configuration is required.</p>

 

<p>For online documentation and support please refer to

<a href=http://nginx.org/>nginx.org</a>.<br/>

Commercial support is available at

<a href=http://nginx.com/>nginx.com</a>.</p>

 

<p><em>Thank you for using nginx.</em></p>

</body>

</html>
```
 
