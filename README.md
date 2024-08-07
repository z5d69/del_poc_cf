Repo: del_poc_cf
Purpose: Create Azure PoC based on requirements from CF.
A number of requirements for this PoC were provided.
Usage: These terraform scripts can be executed from a number of Terraform products.  This was executed using the terraform standalone binary however can also be run on dedicated Terraform instances, in cloud, etc. 
(available here: https://developer.hashicorp.com/terraform/install)
Build Inventory: this will include the list of scripts and a summary of their purpose.  
  terraform.tfvars - includes all the environment variables that are configurable within this PoC.  Region, VNet Name, Resource Group Name, and some storage configuration options, as well as resource tags, are provided here. This will allow the code to run in the preferred space for this PoC in your own environment. All resources will be provisioned in the same resource group and location as the resource group. 
  variables.tf - describes and sets default for variables not defined in terraform.tfvars. 
  resource_group.tf - resource group provisioning.
  availability_set.tf - availability set provisioning to manage some of the VM maintenance schedules.
  nsg.tf - network security group provisioning to restrict access to two subnets.
  provider.tf - provider details required for initializing Terraform repo.
  storage_account.tf - provision storage account with network restriction for access.
  virtual_network.tf - provision vnet.
  subnet.tf - create subnets within virtual network.  a module was leveraged to create these as this will reduce redundant code.  
  modules\subnet\subnet.tf - basically a Terraform version of function to automate consistent configuration of subnets.
  vm.tf - create all the VMs as well as NICs for VMs and associate NICs with subnets.
  load_balancer.tf - creates load balancer that sits in front of sub3 web server.
  rhelapache.sh - installs and starts up the web server (apache) for one of the VMs.  

Build process: 
  more details here: 
  install and configure terraform binary or identify existing instance of Terraform binary / Cloud Terraform.
  download code repo from github, as tarball / zip file or cloning from github.
  make changes in terraform.tfvars as appropriate.
  terraform init - to initialize terraform executable, download terraform libraries, download modules.
  terraform plan - create plan or create and save plan (terraform plan -out=planname)
  terraform apply - apply steps (plan, then apply) or apply steps created in prior plan step (terraform apply "planname")
  (address any errors identified, potentially agent will timeout before completing a request)
  terraform destroy - destroy resources created from repo (present in statefile)
