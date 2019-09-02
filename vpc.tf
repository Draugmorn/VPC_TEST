resource "aws_vpc" "VPC1" {
  cidr_block           = "${var.vpcCIDRblock}"
  instance_tenancy     = "${var.instanceTenancy}" 
  enable_dns_support   = "${var.dnsSupport}" 
  enable_dns_hostnames = "${var.dnsHostNames}"
  tags = {
    Name = "VPC1"
  }
}
resource "aws_subnet" "VPC1_Subnet" {
  vpc_id                  = "${aws_vpc.VPC1.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}" 
  availability_zone       = "${var.availabilityZone}"
  tags = {
	  Name = "VPC1 Subnet"
	}
}
resource "aws_security_group" "VPC1_Security_Group" {
  vpc_id       = "${aws_vpc.VPC1.id}"
  name         = "VPC1 Security Group"
  description  = "VPC1 Security Group"
ingress {
    cidr_blocks = "${var.ingressCIDRblock}"  
    from_port = -1
    to_port = -1
    protocol = "icmp"
    }
ingress {
    cidr_blocks = "${var.ingressCIDRblock}"  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
tags = {
        Name = "VPC1 Security Group"
  }
  }
  resource "aws_network_acl" "VPC1_Security_ACL" {
 vpc_id = "${aws_vpc.VPC1.id}"
 subnet_ids = [ "${aws_subnet.VPC1_Subnet.id}" ]
   ingress {
   protocol   = "tcp"
   rule_no    = 100
   action     = "allow"
   cidr_block = "${var.destinationCIDRblock}"
   from_port  = 22
   to_port    = 22
 }
   egress {
   protocol   = "tcp"
   rule_no    = 100
   action     = "allow"
   cidr_block = "${var.destinationCIDRblock}"
   from_port  = 1024
   to_port    = 65535
 }
 ingress {
   protocol   = -1
   rule_no    = 110
   action     = "allow"
   cidr_block = "${var.destinationCIDRblock}"
   from_port  = 0
   to_port    = 0
 }
   egress {
   protocol   = -1
   rule_no    = 110
   action     = "allow"
   cidr_block = "${var.destinationCIDRblock}"
   from_port  = 0
   to_port    = 0
 }
}
resource "aws_internet_gateway" "Internet_GW" {
  vpc_id = "${aws_vpc.VPC1.id}"
	tags = {
	        Name = "Internet_Gateway"
	    }
}
resource "aws_route_table" "VPC1_route_table" {
    vpc_id = "${aws_vpc.VPC1.id}"
	tags = {
	        Name = "VPC1 Route Table"
	    }
}
resource "aws_route" "VPC1_internet_access" {
  route_table_id        = "${aws_route_table.VPC1_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.Internet_GW.id}"
} 
resource "aws_route_table_association" "VPC1_association" {
    subnet_id      = "${aws_subnet.VPC1_Subnet.id}"
    route_table_id = "${aws_route_table.VPC1_route_table.id}"
}
resource "aws_instance" "Bastion" {
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.VPC1_Subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.VPC1_Security_Group.id}"]
  key_name = "test123"
 tags = {
  "Environment" = "${var.environment_tag}"
 }
}

resource "aws_vpc" "VPC2" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default" 
  enable_dns_support   = "true" 
  enable_dns_hostnames = "true"
  tags = {
    Name = "VPC2"
  }
}

resource "aws_subnet" "VPC2_Subnet" {
  vpc_id                  = "${aws_vpc.VPC2.id}"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = "${var.mapPublicIP}" 
  availability_zone       = "${var.availabilityZone}"
  tags = {
	  Name = "VPC2 Subnet"
	}
}
resource "aws_security_group" "VPC2_Security_Group" {
  vpc_id       = "${aws_vpc.VPC2.id}"
  name         = "VPC2 Security Group"
  description  = "VPC2 Security Group"
ingress {
    cidr_blocks = ["0.0.0.0/0"] 
    from_port = -1
    to_port = -1
    protocol = "icmp"
    }
ingress {
    cidr_blocks = ["0.0.0.0/0"]  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
tags = {
        Name = "VPC2 Security Group"
  }
  }
resource "aws_route_table" "VPC2_route_table" {
    vpc_id = "${aws_vpc.VPC2.id}"
	tags = {
	        Name = "VPC2 Route Table"
	    }
}
resource "aws_network_acl" "VPC2_Security_ACL" {
 vpc_id = "${aws_vpc.VPC2.id}"
 subnet_ids = [ "${aws_subnet.VPC2_Subnet.id}" ]
   ingress {
   protocol   = "tcp"
   rule_no    = 100
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 22
   to_port    = 22
 }
   egress {
   protocol   = "tcp"
   rule_no    = 100
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 1024
   to_port    = 65535
 }
 ingress {
   protocol   = -1
   rule_no    = 110
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 0
   to_port    = 0
 }
   egress {
   protocol   = -1
   rule_no    = 110
   action     = "allow"
   cidr_block = "0.0.0.0/0"
   from_port  = 0
   to_port    = 0
 }
}
resource "aws_route" "VPC2_internet_access" {
  route_table_id        = "${aws_route_table.VPC1_route_table.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id             = "${aws_internet_gateway.Internet_GW.id}"
} 
resource "aws_route_table_association" "VPC2_association" {
    subnet_id      = "${aws_subnet.VPC2_Subnet.id}"
    route_table_id = "${aws_route_table.VPC2_route_table.id}"
}
resource "aws_instance" "InternalHost" {
  ami           = "${var.instance_ami}"
  instance_type = "${var.instance_type}"
  subnet_id = "${aws_subnet.VPC2_Subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.VPC2_Security_Group.id}"]
  key_name = "test123"
 tags = {
  "Environment" = "${var.environment_tag}"
 }
}

resource "aws_vpc_peering_connection" "VPC1toVPC2" {
  vpc_id = "${aws_vpc.VPC1.id}"
  peer_owner_id = "745613350239"
  peer_vpc_id = "${aws_vpc.VPC2.id}"
  auto_accept = true
}
resource "aws_route" "VPC1toVPC2" {
  route_table_id = "${aws_route_table.VPC1_route_table.id}"
  destination_cidr_block = "192.168.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.VPC1toVPC2.id}"
}
resource "aws_route" "VPC2toVPC1" {
  route_table_id = "${aws_route_table.VPC2_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.VPC1toVPC2.id}"
}


