variable "sg_name" {
   description = "security group for roboshop"
}

variable "network_name" {
    type = string
    description = "network for roboshop"
}

variable "subnet_name" {
    type = string
    description = "subnet for roboshop"
}


variable "public_subnet_name" {}
variable "private_subnet_name" {} 
variable "address_space" {}     
variable "private_subnet_address_prefixes" {}  
variable "public_subnet_address_prefixes" {}  
variable "network_rules" {}
variable "private_subnet_nsg_name" {}