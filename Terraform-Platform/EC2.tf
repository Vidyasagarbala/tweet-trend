resource aws_instance servers {
    ami = "ami-04b4f1a9cf54c11d0"
    instance_type = var.instance_type

    //for_each = {for k,v in var.server_list : k => v.server if v.server == "ansible" : key_name = "ansible"}
        //key_name = ansible
      
      for_each = var.server_list
        key_name = each.value.server == "ansible" ? "ansible" : "Dev-ops"
        tags = {
        server = each.value.server
        operating_system = each.value.os
      }
      associate_public_ip_address = true
      subnet_id = aws_subnet.public-subnet.id
      vpc_security_group_ids = [aws_security_group.allow_tls_ssh.id]
 }

 

resource "aws_security_group" "allow_tls_ssh" {
  name        = "allow_tls_ssh"
  description = "Allow TLS & SSH inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.dev-ops.id

  tags = {
    Name = "allow_tls_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_rules" {
  for_each = { for idx, rule in var.ingress_rules : idx => rule }

  security_group_id = aws_security_group.allow_tls_ssh.id
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  ip_protocol       = each.value.protocol
  cidr_ipv4         = each.value.cidr_blocks[0]
  description       = each.value.description
}

resource "aws_vpc_security_group_egress_rule" "egress_rules" {
  for_each = { for k,v in var.egress_rules : k => v }  
  security_group_id = aws_security_group.allow_tls_ssh.id
  cidr_ipv4   = each.value.cidr_blocks[0]
  from_port   = each.value.from_port
  ip_protocol = each.value.protocol
  to_port     = each.value.to_port
}