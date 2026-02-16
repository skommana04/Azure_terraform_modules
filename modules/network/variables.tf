variable "sg_name" {
    type = list()
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

variable "address_space" {}     
variable "address_prefixes" {}   
