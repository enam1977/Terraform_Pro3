
Title: Ensuring Quality Releases

Prerequisites:

Install Packer,Terraform, Azure CLI and VSCode Editor in order to create the project. Follow the below link to install the tools. My information based on Mac OOS. So provided shell commands are for Mac OS.

Create Azure account https://azure.microsoft.com/en-us/free/ From above link you can create a azure account for the project to create your resources.

Homebrew is the place where all packages can be found to install(https://brew.sh/)

Install Packer

Install Terraform CLI

Install CLI

Install Azure CLI

Install VS Code Editor

Install HashiCorp Terraform plugin for VS Code

Install Git Client

Installation procedures:

Install Brew
First you need to install Homebrew, a powerful package manager for Mac. You can install following below command.

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install XCode
brew update xcode-select --install The reason to install xcode is that some software packages, usually open-source Unix packages, come with source code instead of a prebuilt binary file to install.

Install Python 3:
$ brew install python AZ CLI does not work without Python 3 install into the system.

Selenium

Download the latest Chrome driver.
pip install -U selenium
sudo apt-get install -y chromium-browser
IMPORTANT You will need to add the chromedriver to PATH.
In the Project Starter Resources folder, in the Selenium folder, execute the login.py file to open the demo site.

JMeter
Install JMeter.-https://jmeter.apache.org/download_jmeter.cgi
Use JMeter to open the Starter.jmx file in the “Project Starter Resources” JMeter folder.
Replace the APPSERVICEURL with the URL of your AppService once it's deployed.

Postman
Install Postman.-https://www.postman.com/downloads/
Import into Postman the starterAPIs.json collection from the Project Starter Resources.

AZ CLI Current Version (if installed)
az --version

Install Azure CLI (if not installed)
brew update brew install azure-cli

Upgrade az cli version
az --version brew upgrade azure-cli [or] az upgrade az --version

Install terraform from brew
brew install terraform

To confirm the installation, type terraform -v and you will get the current version as the output.

Terraform - Authenticating using the Azure CLI:

Azure Provider: Authenticating using the Azure CLI
Azure CLI Login
az login This command gets you to the azure portal where you have to provide credentials to get into the portal.

List Subscriptions
az account list This command get you the list of subscriptions associated with the account. In the list you will also get the subscription IDs.

Set Specific Subscription (if we have multiple subscriptions)
az account set --subscription="SUBSCRIPTION_ID" if you have more than one subscription IDs you need to set one to work for terraform. IF you have just one no need to do anything.

Install Git Client
Download Git Client
This is required when we are working with Terraform Modules
Now we are done with all our installation and get ready in order to write coding in Packer and Terraform

Use Packer to create virtual image:

Create Resource Group and location
https://docs.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer In order to create Packer VM image you need to first create resource group and the location. There are so many option for location but i use "EAST-US". You can create login to the portal or using azure CLI. See the CLI command below to crease resource and location

az group create -Name terraform-storage-rg -Location eastus

Create Azure Storage Account
- Create Resource Group
Go to Resource Groups -> Add
Resource Group: terraform-storage-rg
Region: East US
Click on Review + Create
Click on Create
- Create Azure Storage Account
Go to Storage Accounts -> Add
Resource Group: terraform-storage-rg
Storage Account Name: udacitystorage
Region: East US
Performance: Standard
Redundancy: Geo-Redundant Storage (GRS)
In Data Protection, check the option Enable versioning for blobs
REST ALL leave to defaults
Click on Review + Create
Click on Create

- Create Container in Azure Storage Account
Go to Storage Account -> udacitystorage -> Containers -> +Container
Name: tfstatefiles
Public Access Level: Private (no anonymous access)
Click on Create

- Create service principle
Below command create a service principle and get you credentials to use to run packer and terraform.

az ad sp create-for-rbac -n "Uacity_P3" --role Contributor --query "{ client_id: appId, client_secret: password, tenant_id: tenant }"


"client_id": "21331ae3-df85-4cc9-be3e-445508caa15c",
"client_secret": "ceceabee-a05b-4155-b05c-4b6a28371b2f",
"tenant_id": "dd152091-7e9a-448e-b6a0-223f687a2d84"

Find Subscription IDs
you will get above credentials by creating service principle but you also need subscription IDs that you can have using the following

   az account show --query "{ subscription_id: id }"

   Subscription_id: "50d65e48-cd36-43c6-b861-3b1bcc7804e9"

Terraform in Azure

Configure the Linux VM for deployment:

SSH into the VM using the Public IP
Alternatively, you can use the 'Reset Password' function in Azure for the VM resource and then try SSH using those credentials.
Follow the instructions to create an environment in Azure DevOps
If the registration script shows "sudo: ./svc.sh: command not found":
sudo bin/installdependencies.sh
cd ..
sudo rm -rf azagent
Run the registration script again.
Add your user to the sudoers file.
Update azure-pipelines.yaml with the Environment, and run the pipeline. You can now deploy to the Linux VM.
Configure Logging for the VM in the Azure Portal.

Use Terraform to create the following resources for a specific environment tier:
AppService
Network
Network Security Group
Public IP
Resource Group
Linux VM (created by you -- use a Standard_B1s size for lowest cost)

[Configure the storage account and state backend.](https://docs.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage)

    For the sake of simplicity, run the bash script [config_storage_account.sh](config_storage_account.sh) in the local computer. Then replace the values below in [terraform/environments/test/main.tf](terraform/environments/test/main.tf) with the output from the Azure CLI in a block as

    ```
    terraform {
        backend "azurerm" {
            resource_group_name  = "${var.resource_group}"
            storage_account_name = "tstate12785"
            container_name       = "tstate"
            key                  = "terraform.tfstate"
        }
    }
    ```

    . [Install Terraform Azure Pipelines Extension by Microsoft DevLabs.](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)

5. Create a new Service Connection by Project Settings >> Service connections >> New service connection >> Azure Resource Manager >> Next >> Service Principal (Automatic) >> Next >> Choose the correct subscription, and name such new service connection to Azure Resource Manager as `azurerm-sc`. This name will be used in [azure-pipelines.yml](azure-pipelines.yml).

    ![Service connections 1](screenshots/service_connections_1.png)

    ![Service connections 2](screenshots/service_connections_2.png)

    6. Add TerraformTaskV1@0 tasks to perform `terraform init` and `terraform apply` in [azure-pipelines.yml](azure-pipelines.yml) to let them run in the Azure Pipelines build agent as if running in the local computer.

7. Build FakeRestAPI artifact by archiving the entire fakerestapi directory into a zip file and publishing the pipeline artifact to the artifact staging directory.

8. Deploy FakeRestAPI artifact to the terraform deployed Azure App Service. The deployed webapp URL is [http://lingchenzhu-webapi-appservice.azurewebsites.net/](http://lingchenzhu-webapi-appservice.azurewebsites.net/) where `lingchenzhu-webapi-appservice` is the Azure App Service resource name in small letters.

    ![Deployed fakerestapi](screenshots/deployed_fakerestapi.png)

9. After terraform deployed the virtual machine in Azure Pipelines, we need to manually register such virtual machine in Pipelines >> Environments >> TEST >> Add resource >> Select "Virtual machines" >> Next >> In Operating system, select "Linux". Then copy the Registration script, manually ssh login to the virtual machine, paste it in the console and run. Such registration script makes the deployed Linux virtual machine an Azure Pipelines agent so Azure Pipelines can run bash commands there.

    ![Environments VM](screenshots/environments_vm.png)

    Then Azure Pipelines can run bash commands on the virtual machine deployed by terraform.

10. [Create an Azure Log Analytics workspace.](https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-create-workspace-cli)

    Run [deploy_log_analytics_workspace.sh](deploy_log_analytics_workspace.sh), or directly call `az deployment group create --resource-group udacity-ensuring-quality-releases --name deploy-log --template-file deploy_log_analytics_workspace.json`, and provide a string value for the parameter `workspaceName`, say `udacity-ensuring-quality-releases-log`.

11. [Install Log Analytics agent on Linux computers.](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/agent-linux)

    Follow the instructions to install the agent using wrapper script: `wget https://raw.githubusercontent.com/Microsoft/OMS-Agent-for-Linux/master/installer/scripts/onboard_agent.sh && sh onboard_agent.sh -w <YOUR WORKSPACE ID> -s <YOUR WORKSPACE PRIMARY KEY>` on the terraform deployed VM.
    
    Both ID and primary key of the Log Analytics Workspace can be found in the Settings >> Agents management of the Log Analytics workspace and they can be set as secret variables for the pipeline.

    After finishing installing the Log Analytics agent on the deployed VM, Settings >> Agents management should indicate that "1 Linux computers connected".

    ![Log analytics workspace agents management](screenshots/log_analytics_workspace_agents_management.png)

12. [Collect custom logs with Log Analytics agent in Azure Monitor.](https://docs.microsoft.com/en-us/azure/azure-monitor/platform/data-sources-custom-logs)

    ![Log analytics workspace custom logs](screenshots/log_analytics_workspace_custom_logs.png)

13. [JMeter Command Line Options reference](http://sqa.fyicenter.com/1000056_JMeter_Command_Line_Options.html)

14. [Newman Command Line Options reference](https://learning.postman.com/docs/running-collections/using-newman-cli/command-line-integration-with-newman/)

15. Verify Azure Monitor Logs collected from the Log Analytics agent installed on the deployed VM.

    ![Logs collected from VM](screenshots/azure_log_analytics_logs_from_vm.png)























# Terraform_Pro3

Step-05: Install Terraform Extension for Azure DevOps
Terraform Extension for Azure DevOps

Terraform in Azure
Configure the storage account and state backend. Replace the values below in terraform/environments/test/main.tf with the output from the Azure CLI:

storage_account_name
container_name
access_key

Create a Service Principal for Terraform Replace the below values in terraform/environments/test/terraform.tfvars with the output from the Azure CLI:

subscription_id
client_id
client_secret
tenant_id

Azure DevOps
Import the two files azure-pipelines.yaml and StarterAPIs.json into Azure DevOps.
Follow the instructions to create a new Azure Pipeline from the azure-pipelines.yaml file.


Selenium
Download the latest Chrome driver.
pip install -U selenium
sudo apt-get install -y chromium-browser
IMPORTANT You will need to add the chromedriver to PATH.
In the Project Starter Resources folder, in the Selenium folder, execute the login.py file to open the demo site.
JMeter
Install JMeter.
Use JMeter to open the Starter.jmx file in the “Project Starter Resources” JMeter folder.
Replace the APPSERVICEURL with the URL of your AppService once it's deployed.
Postman
Install Postman.
Import into Postman the starterAPIs.json collection from the Project Starter Resources.
Dev Environment
Open the files in the Project Starter Resources folder using the IDE of your choice.
Complete the "Getting Started,” and each of the "Installation" sections.
Create an SSH key pair for the linux machine. Use the reference to the file for the Dev Environment. Use the actual public key itself when using Terraform in the CI/CD pipeline.
Run the terraform commands to create the resources in Azure.
.\path\to\terraform\terraform.exe init
.\path\to\terraform\terraform.exe apply
At this point, you are able to:

Write automated tests in Postman, JMeter and Selenium.
Check-in changes to the Git repo in Azure DevOps.
Run the CI/CD pipeline to deploy changes to an AppService. If this does not load, you may need to check the AppService Configuration in Azure and ensure WEBSITE_RUN_FROM_PACKAGE is set to 0.
Note that the deployment to the VM will fail since it is not configured as a deployment target yet.
Configure the Linux VM for deployment:

SSH into the VM using the Public IP
Alternatively, you can use the 'Reset Password' function in Azure for the VM resource and then try SSH using those credentials.
Follow the instructions to create an environment in Azure DevOps
If the registration script shows "sudo: ./svc.sh: command not found":
sudo bin/installdependencies.sh
cd ..
sudo rm -rf azagent
Run the registration script again.
Add your user to the sudoers file.
Update azure-pipelines.yaml with the Environment, and run the pipeline. You can now deploy to the Linux VM.
Configure Logging for the VM in the Azure Portal.



Project Instructions
Starter Resources
Please download the “Project Starter Resources” zip file from the Resources tab in the left sidebar of your classroom here. There are a variety of files in there that will be necessary or helpful to you, referred to throughout the directions below as “starter” files.

Starter Resources Description
azure-pipelines.yaml: the starter pipeline, use this to build out the terraform tasks, and kick-off automated tests for Postman, Selenium, and JMeter
StarterAPI.json: use these APIs in Postman and build the Regression Test Suite and Data Validation Test Suite
/terraform: this holds all of the files needed for creating the test environment
/jmeter: this hold all of the files needed to create the Stress Test and Endurance Test Suites
/postman: use these APIs in Postman and build the Regression Test Suite and Data Validation Test Suite
/selenium: build on this existing script to Complete the UI Test Suite task
Project Steps
Please complete the following steps for this project:

Use Terraform to create the following resources for a specific environment tier:
AppService
Network
Network Security Group
Public IP
Resource Group
Linux VM (created by you -- use a Standard_B1s size for lowest cost)
For the Azure DevOps CI/CD pipeline:
Create the tasks that allow for Terraform to run and create the above resources.
Execute Test Suites for:
Postman - runs during build stage
Selenium - runs on the linux VM in the deployment stage
JMeter - runs against the AppService in the deployment stage
For Postman:
Create a Regression Test Suite from the Starter APIs. Use the Publish Test Results task to publish the test results to Azure Pipelines.
Create a Data Validation Test Suite from the Starter APIs.
For Selenium:
Create a UI Test Suite that adds all products to a cart, and then removes them.
Include print() commands throughout the tests so the actions of the tests can easily be determined. E.g. A login function might return which user is attempting to log in and whether or not the outcome was successful.
Deploy the UI Test Suite to the linux VM and execute the Test Suite via the CI/CD pipeline.
For JMeter:
Use the starter APIs to create two Test Suites. Using variables, reference a data set (csv file) in the test cases where the data will change.
Create a Stress Test Suite
Create a Endurance Test Suite
Generate the HTML report (non-CI/CD) IMPORTANT: Since the AppService is using the Basic/Free plan, start small (2 users max) and once you are ready for the final submission, use up to 30 users for a max duration of 60 seconds. The "Data Out" quota for the AppService on this plan is only 165 MiB.
For Azure Monitor:
Configure an Action Group (email)
Configure an alert to trigger given a condition from the AppService
The time the alert triggers and the time the Performance test is executed ought to be very close.
Direct the output of the Selenium Test Suite to a log file, and execute the Test Suite. Configure custom logging in Azure Monitor to ingest this log file.This may be done non-CI/CD.
Tips for Creating a Successful “Ensuring Quality Releases” Project
Start with Terraform. It will create the resources you need to move to the next steps in the project.
Continue on with adding the execution of the test suites to Azure DevOps. Start with the starter code for each just to make sure each is executing correctly before you create your test suites.
Create your test suites for each. Remember to ensure JMeter is only using a max of 2 users, otherwise you will reach the quota limit for the AppService.
Then create your alert for the AppService.
And finally, configure log analytics and direct the output there.
Remember the concepts and skills you've learned from the lessons.
Remember also you may submit your project work any number of times, until you pass. Read and make good use of the feedback you receive on any submission that you don’t pass.
Above all take your time, and have fun!

Check your Work Against the Project Rubric Before Submitting
Before you submit your work, please check it against the project rubric. Revise any area of your work where you have not met the specifications for the criterion for passing the project.

This is the same rubric that your reviewer will be using to assess your work. You need to satisfy every criterion in the rubric to pass the project.

You may submit your project work as many times as you need to pass. After you receive your feedback from the reviewer, if you haven't passed yet, then make sure to read the reviewer's comments carefully, make the required revisions, and submit your work again!

Project Submission Requirements
Please create the following, then zip all these up into one zip archive for your project submission.

A zip archive of all Terraform tf files and tfvars files. A screenshot of the log output of Terraform when executed by the CI/CD pipeline (ensure the timestamp is visible by toggle timestamps for the specific job).
The azure-pipelines.yaml and a screenshot of the successful execution of the pipeline. The screen shot should be of the build results page (this path will be in the URL of the correct page: /_build/results?buildId={id}&view=results). This will not show errors and the time stamp for this ought to correspond closely to the timestamps in the screenshots that are submitted.
A zip archive of the two Postman collections and environment. Three screenshots of the Test Run Results from Postman shown in Azure DevOps. One should be the Run Summary page (which contains 4 graphs), one should be of the Test Results page (which contains the test case titles from each test) and one should be of the output of the Publish Test Results step.
A zip archive of the Selenium python files. A screenshot of the successful execution of the Test Suite on a VM in Azure DevOps should contain which user logged in, which items were added to the cart, and which items were removed from the cart.
A zip archive ot the JMeter test results for each test suite. This is an HTML report generated by JMeter. A screenshot of the log output of JMeter when executed by the CI/CD pipeline (ensure the timestamp is visible by toggle timestamps for the specific job) should contain the lines that start with “summary” and “Starting standalone test @”.
Screenshots of the email received when the alert is triggered, the graphs of the resource that the alert was triggered for (be sure to include timestamps for the email and the graphs), and the alert rule, which will show the resource, condition, action group, alert name, and severity. Screenshots for the resource’s metrics will correspond to the approximate time that the alert was triggered.
Screenshots of log analytics queries and result sets which will show specific output of the Azure resource. The result set will include the output of the execution of the Selenium Test Suite (be sure to include timestamps).






mkdir azagent;cd azagent;curl -fkSL -o vstsagent.tar.gz https://vstsagentpackage.azureedge.net/agent/2.195.0/vsts-agent-linux-x64-2.195.0.tar.gz;tar -zxvf vstsagent.tar.gz; if [ -x "$(command -v systemctl)" ]; then ./config.sh --environment --environmentname "udacity" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/enambd/ --work _work --projectname 'Terraform_Project3' --auth PAT --token rtcbgfoyls34tavwewxpeph2gg4x5ysvifzc72vd4s7h5rdgci3a --runasservice; sudo ./svc.sh install; sudo ./svc.sh start; else ./config.sh --environment --environmentname "udacity" --acceptteeeula --agent $HOSTNAME --url https://dev.azure.com/enambd/ --work _work --projectname 'Terraform_Project3' --auth PAT --token rtcbgfoyls34tavwewxpeph2gg4x5ysvifzc72vd4s7h5rdgci3a; ./run.sh; fi



https://learndevtestops.com/2021/03/14/selenium-python-tests-azure-devops-integration-made-for-each-other/
https://azuredevopslabs.com/labs/vstsextend/selenium/

https://ooeid-omar.medium.com/ensuring-quality-release-using-microsoft-azure-4fd3af7101d6

Connect to the virtual machine using PowerShell
If you are using PowerShell and have the Azure PowerShell module installed you may also connect using the Get-AzRemoteDesktopFile cmdlet, as shown below.

This example will immediately launch the RDP connection, taking you through similar prompts as above.

PowerShell

Copy
Get-AzRemoteDesktopFile -ResourceGroupName "terraform-storage-rg" -Name "ATT-dev-web-linuxvm" -Launch
You may also save the RDP file for future use

Get-AzRemoteDesktopFile -ResourceGroupName "terraform-storage-rg" -Name "ATT-dev-web-linuxvm" -LocalPath "/Users/enamulhaque/Downloads/ATT-dev-web-linuxvm.rdp"

Automating Selenium Tests in Azure Pipelines
https://azuredevopslabs.com//labs/vstsextend/selenium/#exercise-1-configure-agent-on-the-vm

System prerequisites
Configure your account
Configure your account by following the steps outlined here.
Download the agent
Download	
Create the agent
~/$ mkdir myagent && cd myagent
~/myagent$ tar zxvf ~/Downloads/vsts-agent-osx-x64-2.195.0.tar.gz
Configure the agentDetailed instructions
~/myagent$ ./config.sh
Optionally run the agent interactively
If you didn't run as a service above:
~/myagent$ ./run.sh


need to run this to allowa unauthrized apps to run in mac
sudo spctl --master-disable


projec 3 demo
https://ooeid-omar.medium.com/ensuring-quality-release-using-microsoft-azure-4fd3af7101d6



How postman works explains good............

https://www.youtube.com/watch?v=VywxIQ2ZXw4&t=1117s


this one well explain what to do well
https://ganeshsirsi.medium.com/how-to-configure-postman-newman-api-tests-in-azure-devops-or-tfs-and-publish-html-results-caf60a25c8b9 

## creating VM in the pipelien

https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments-virtual-machines?view=azure-devops


As Kyaw mentioned, the VM is configured on the environment section so that the pipeline can communicate with it. Below are some simple steps.

- Click Create Environment.

- Specify a Name (required) for the environment and a Description.

- Choose Virtual Machines as a Resource to be added to the environment and click Next.

- Choose Windows or Linux for the Operating System.

- Copy the registration script.

- Run the copied script from an administrator PowerShell command prompt on each of the target VMs that you want to register with this environment.


The VM is used in this project to run the Selenium tests, so your terraform needs to create a VM able to run selenium tests. Since it will run in Azure Pipelines you need to run the selenium tests in headless mode.


Pre-requisite Note: Create SSH Keys for Azure Linux VM
# Create Folder
cd terraform-manifests/
mkdir ssh-keys

# Create SSH Key
cd ssh-ekys
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f terraform-azure.pem 
Important Note: If you give passphrase during generation, during everytime you login to VM, you also need to provide passphrase.

# List Files
ls -lrt ssh-keys/

# Files Generated after above command 
Public Key: terraform-azure.pem.pub -> Rename as terraform-azure.pub
Private Key: terraform-azure.pem

# Permissions for Pem file
chmod 400 terraform-azure.pem


nams-MacBook-Pro:terraform-manifests enamulhaque$ export ARM_CLIENT_ID="3a55cc2f-6f87-4fb4-9258-28f637136ee6"
Enams-MacBook-Pro:terraform-manifests enamulhaque$ export ARM_TENANT_ID="dd152091-7e9a-448e-b6a0-223f687a2d84"
Enams-MacBook-Pro:terraform-manifests enamulhaque$ export ARM_SECRET_ID="0b049f26-84b7-4a8e-b693-dc0ec1d36067"
Enams-MacBook-Pro:terraform-manifests enamulhaque$ export ARM_SUBSCRIPTION_ID="50d65e48-cd36-43c6-b861-3b1bcc7804e9"


## Install SSH Key task
https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/install-ssh-key?view=azure-devops



https://github.com/zhulingchen/Azure-Cloud-DevOps-Ensuring-Quality-Releases/blob/main/README.md

https://github.com/acouprie/udacity-azure-project3/blob/master/README.md


https://dev.azure.com/enambd/Terraform_Project3/_build/results?buildId=500&view=artifacts&pathAsName=false&type=publishedArtifacts

https://www.tutorialspoint.com/yaml/yaml_comments.htm


self host  agent

https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-osx?view=azure-devops