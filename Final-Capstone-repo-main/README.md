# Sprints-Capstone-Project
# Jenkins Setup Guide

This guide provides step-by-step instructions to set up Jenkins using Terraform and Ansible. It covers the installation process, connecting to Jenkins, creating user accounts, configuring credentials, and setting up a GitHub webhook for automation.

## Prerequisites

Before you begin, ensure you have the following prerequisites:

- Terraform installed
- Ansible installed
- AWS account and AWS CLI configured
- SSH access to the target server

## Installation Steps

### Step 1: Terraform Setup

1. Run the following commands in your terminal to initialize Terraform and apply the configuration:

   ```shell
   terraform init
   terraform plan
   terraform apply
   ```
## Step 2: Install Jenkins using Ansible
Run the following Ansible playbook commands to install Jenkins, Docker, AWS CLI, and kubectl:

   ```shell
   ansible-playbook docker.yml -i inventory.txt
   ansible-playbook Jenkins.yml -I inventory.txt
   ansible-playbook awscli.yml -i inventory.txt
   ansible-playbook kubectl.yml -i inventory.txt
   ```
##Step 3: Unlock Jenkins
Connect to the Jenkins server via SSH and run the following commands to retrieve the initialAdminPassword:

   ```shell
   ssh user@jenkins-server-ip
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```
Copy the output and use it as the administrator password to unlock Jenkins.

### Step 4: Configure Jenkins
Access Jenkins via a web browser using http://jenkins-server-ip:8080.

Follow the setup wizard to install suggested plugins.

Create a user account by providing a username, password, and email.

### Step 5: Add AWS Credentials
Access Jenkins via a web browser and go to "Manage Jenkins" > "Manage Credentials" > "System" > "Global credentials".

Add your AWS credentials using the following command and save it in the credentials section:

```shell
cat ~/.aws/credentials
```
### Step 6: Configure GitHub Webhook
In your GitHub repository, go to "Settings" > "Webhooks".

Enter the following URL as the Payload URL: http://jenkins-server-ip:8080/github-webhook/.

Configure the webhook settings and create the webhook.

### Step 7: Create Multibranch Pipeline
Access Jenkins via a web browser and go to "Dashboard" > "New Item" > "Multibranch Pipeline".

Configure the pipeline by providing your GitHub credentials, repository URL, and discovering branches.

Save the configuration.

## Conclusion
You have successfully set up Jenkins using Terraform and Ansible, configured user accounts, credentials, and created a GitHub webhook for automation. You can now build and manage your pipelines with Jenkins.
