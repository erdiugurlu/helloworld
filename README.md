# Simple Golang Application and DevOps Project

This repository contains a dockerize application in Go language. Additionally, Ansible YAML files and Helm charts prepared for building and deploying the service on a Minikube cluster. If you have the following configurations and this repository, after you update your code or configuration, you can deploy your service on a Minikube server automatically.

You can update image version by editing values.yaml, Chart.yaml and buildImage.yaml

When you push your codes on your computer to your repository, Jenkins server is pulling your code and forwarding them into Ansible server for building image and Minikube Server for deploying the service on Minikube by using Helm.

### Before you begin

You have 3 servers(two EC2 instances and one Ubuntu instance) which are running on Jenkins, Ansible and Minikube to run this IaC. 

### Minikube Configuration

In order to operate Minikube and deployment on the Kubernetes platform, I installed an ubuntu server on AWS and configured some tasks in the following lines.
  * Passwordauthentication was enabled for integration of Jenkins by editing sshd_config 
  * jenkinsusr was defined in the server.
  * minikube and helm were installed.  
  * Metrics-server was enabled for HPA in minikube.
  * Public key of the Ansible Server was added on id_rsa.pub of the Minikube server.

### Ansible Server Configuration

In order to use Ansible, I installed Python, Python-Pip and Ansible on an EC2 instance. You can see my preparations in the server in the following lines. 
  * Passwordauthentication was enabled for integration of Jenkins by editing sshd_config
  * ansadmin was defined in the server.
  * Docker installed on the server for building images and I login my Docker Hub for pushing images.
  * a file was created in `/home/ansadmin` with naming hosts. 
  * `localhost`, group name of localhost(`ansibleserver`), `public ip of Minikube server` and group name(`minikube`) of Minikube server were defined in the server.

### Jenkins configuration

Jenkins server is managing all of the things. It is pulling files from the repository and emitting them to Ansible and Minikube servers. 

Before I run the Jenkins project, SSH and Git plugins were installed on the server. Afterwards, I defined the Ansible Host and the Minikube Server in Jenkins Configuration.

#### From Jenkins home page select "New Item"
   - Enter an item name: `Deploy_on_Container_using_ansible`
   - *Source Code Management:*
      - Repository:`https://github.com/erdiugurlu/helloworld.git`
      - Branches to build : `*/master`
   - *Poll SCM* :      - `* * * *`
   - *Build Environment:*
     - Send files or execute commands over SSH before the build starts
       - SSH Server Name: ansible_host
       - Source Files: `**/*`
       - Remote directory: `//home//ansadmin//package`
       - Exec command: `cd /home/ansadmin; ansible-playbook -i hosts package/buildImage.yaml;rm -rf /home/ansadmin/package/*;`
    - *Build Environment#2:*
     - Send files or execute commands over SSH after the build starts
       - SSH Server Name: minikube
       - Source Files: `**/*`
       - Remote directory: `//home//jenkinsusr//package`
    - *Post-build Actions:*
     - Send files or execute commands over SSH after the build starts
       - SSH Server Name: ansible_host
       - Source Files: `**/*`
       - Remote directory: `//home//ansadmin//package`
       - Exec command: `cd /home/ansadmin; ansible-playbook -i hosts package/deployImage.yaml;`