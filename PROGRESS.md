# Progress

I'll be dumping my thoughts throughout this code challenge here.

Load balancing across 3 subnets under the same region but different availability zones. This should reduce the risk of provider downtime, which will cause our web server to become unavailable.

I will be using a VPC with public subnets for the VMs. Ideally if we're building a stateful application, we'll be deploying a private subnet to house the things like an RDS. Have the VM then speak to the RDS via route tabling to the private subnet.
