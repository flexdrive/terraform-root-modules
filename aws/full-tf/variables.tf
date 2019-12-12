variable "region" {
  default = "us-west-2"
}
variable "AmiLinux" {
  type = "map"
  default = {
    us-east-1 = "ami-b73b63a0" # Virginia
    us-west-2 = "ami-0c3d256527de69215" # Oregon
    eu-west-1 = "ami-9398d3e0" # Ireland
    us-east-2 = "ami-ea87a78f" # Ohio
  }
}

variable "vpc-fullcidr" {
    default = "172.28.0.0/16"
  description = "the vpc cdir"
}
variable "Subnet-Public-AzA-CIDR" {
  default = "172.28.0.0/24"
  description = "the cidr of the subnet"
}
variable "Subnet-Private-AzA-CIDR" {
  default = "172.28.3.0/24"
  description = "the cidr of the subnet"
}
variable "key_name" {
  default = "fd-devops"
  description = "the ssh key to use in the EC2 machines"
}
variable "DnsZoneName" {
  default = "fd-garage.internal"
  description = "the internal dns name"
}
