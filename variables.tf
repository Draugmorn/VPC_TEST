variable "region" {
 default = "us-west-2"
}
variable "availabilityZone" {
        default = "us-west-2a"
}
variable "instanceTenancy" {
 default = "default"
}
variable "dnsSupport" {
 default = true
}
variable "dnsHostNames" {
        default = true
}
variable "vpcCIDRblock" {
 default = "10.0.0.0/16"
}
variable "subnetCIDRblock" {
        default = "10.0.2.0/24"
}
variable "destinationCIDRblock" {
        default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = "list"
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
        default = true
}
variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-0be8af6eb131be7cb"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t2.micro"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Production"
}
