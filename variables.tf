variable "region" {
  description = "Project region"
  type        = string
  default     = "us-east-1"
}

variable "ami_name" {
  description = "EC2 ami Name tag"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "web_server" {
  description = "EC2 web server name"
  type        = string
  default     = "web-server"
}
