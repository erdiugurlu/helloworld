# Simple Golang Application and DevOps Project

This repository contains dockerize application in Go, Ansible YAML files and Helm charts. You can build and update your application and deploy it on a Minikube server. 

### Before you begin

You have 3 servers(two EC2 instances and one Ubuntu instance)to install Jenkins, Ansible and Minikube to run this pipeline and the application. 

### Minikube Configuration
In order to operate Minikube and deployment on the Kubernetes platform, I installed an ubuntu server on AWS and configured some tasks in the following lines.
  * Passwordauthentication was enabled for integration of Jenkins by editing sshd_config 
  * jenkinsusr was defined in the server.
  * minikube and helm were installed.  
  * Metrics-server was enabled for HPA in minikube.
  * Public key of the Ansible Server was added on id_rsa.pub of the Minikube server.

### Ansible Server Configuration
In order to use Ansible, I installed Python Python-Pip and Ansible on an EC2 instance. You can see my preparations in the server in the following lines. 
  * Passwordauthentication was enabled for integration of Jenkins by editing sshd_config
  * ansadmin was defined in the server.
  * Docker installed on the server for building images and I login my Docker Hub for pushing images.
  * a file was created in /home/ansadmin with naming hosts. 
  * localhost, group name of localhost(ansibleserver), public ip of Minikube server and group name of Minikube server were defined in the server.

### Jenkins configuration
Jenkins server is managing all of the things. It is pulling files from the repository and emitting them to Ansible and Minikube servers. 
The project details shared in the following lines.
   * Before I run the project, SSH and Git plugins were installed on the server. 