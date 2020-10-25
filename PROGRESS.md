# Progress

I'll be dumping my thoughts throughout this code challenge here.

Load balancing across 3 subnets under the same region but different availability zones. This should reduce the risk of provider downtime, which will cause our web server to become unavailable.

## VPC setup

I will be using a VPC with public subnets for the VMs. Ideally if we're building a stateful application, we'll be deploying a private subnet to house the things like an RDS. Have the VM then speak to the RDS via route tabling to the private subnet.

## Immutable infrastructure

There's a few articles out there to provision infrastructure with application artifacts pre-deployed on the image using tools like Packer. Though this can cause friction in terms of throughput for Developers to make application changes. There is a benefit in this if the VM is small in nature. Provisioning large virtual machines through code, along with multiple applications on top will cause long lead times.

Solution to this would be split the deployment lifecycle of the underlying infrastructure (Terraform) and application deployment (Ansible). Though for the sake of a **simple** demo, I'll try put them together on the first run.

## Management console / Jumpbox for Ansible deployments

Building a separate EC2 instance tasked to manage deployments would be beneficial to offload deployment from our local machines. The alternative would be using CI agents in a pipeline to run Ansible tasks to deploy applications. Another benefit to this is that we can place the VM in a private subnet, only allowing access to application hosted instances to apply Ansible changes.

There are outstanding risks in building a bastion server in terms of access control (security).

## How to deploy this Python application from source

Let's use the source repository as the source of truth. Ideally we'd use Git tags to lock down changes from applications. Perhaps a staging environment to deploy changes.

## Dynamic Ansible inventory from Terraform

I've read a few repos and blogs and there a tool that I've used to dynamically import deployed Terraform EC2 instances into Ansible inventories. This is done by a combination of a provider, along with an auxiliary script to parse it as inventory for Ansible to apply changes to the host. This one is pretty powerful as it doesn't require a semi-automatic deployment of the VM where the **manual** setup would be to fetch outputs from Terraform to somehow load into Ansible.

Though this doesn't seem like a problem with a small set of VMs. But once we intake more instances from other teams, we reach scaling issues in terms of using ad-hoc scripts to glue the two components together. We'd essentially throw this process into a CI/CD pipeline to automate it from the start. This provides a good platform for developers to easily spin up instances on-demand with relevant specs without **manual** operator intervention.

## Dynamically adding the SSH private keys through Ansible inventory

Ideally we'd want the deployment process to be as automated as possible. But this feature seems like it cannot be done through Ansible due to this [GitHub issue](https://github.com/ansible/ansible/pull/22764). We need to pass the key in via stdout but that's not a feature in Ansible at the moment.

Fallback solution is to generate the key locally and pass it into the Terraform templates. There should be wider discussions on how we maintain keys going forward, the recommended way would be to use a bastion server or store keys in a secret vault like AWS SecretsManager or HashiCorp Vault.

## Using Flask as the web server

I've noticed that the test application uses Flask. We can run the task inline with a command though that's mainly for development purposes.
