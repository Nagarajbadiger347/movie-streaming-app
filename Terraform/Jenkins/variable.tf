variable "region" {
    default = "us-east-1"
    description = "AWS Region"
    type = string  
}

variable "subnet_zone" {
    default = "a"
    description = "Subnet Zone"
    type = string  
}
variable "instance_type" {
    description = "type of instance you went to call"
    default = "t2.micro"
    type = string
}
variable "vpc_cidr" {
    description = "vpc cidr "
    default = "10.0.0.0/16"  
}

variable "subnet_cidr" {
    description = "subnet cidr"
    default = "10.0.1.0/24"  
}
