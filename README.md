# AWS Lab Project (Done using Terraform)

This project is an AWS Lab project - Cloud Web Application Builder built using **Terraform**. It demonstrates the setup and configuration of a scalable and decoupled web application architecture on AWS.

## Overview

The infrastructure includes:

- VPC with public and private subnets (2 each) across two availability zones
- Internet Gateway and route tables for network configuration
- Application Load Balancer
- Auto Scaling Group (ASG) for EC2 instances
- Amazon RDS MySQL database in private subnets
- Attaches IAM instance profile using data (Lab project does not allow us to create a iam profile/role)
- Each instance is launched using a AWS key pair for SSH access

## Purpose

The goal of this project is to demonstrate:

- Infrastructure as Code (IaC) using Terraform
- Separation of application and database layers
- Secure cloud architecture design
- Basic autoscaling and load balancing setup
- AWS best practices for network isolation and security

## Notes

- Database credentials are managed securely using AWS Secrets Manager, IAM instance profile has a role attached to it that enables fetching secrets.
- EC2 instances are launched via ASG using a launch template.
- Application traffic is routed through an application load balancer.
- Private subnets are used for database isolation.

---
This project was created as part of an AWS infrastructure and DevOps learning exercise.
