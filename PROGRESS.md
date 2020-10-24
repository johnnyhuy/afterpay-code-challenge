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
