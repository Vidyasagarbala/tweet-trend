variable cidr_vpc{
    default = "10.10.0.0/16"
}

variable cidr_subnet{
    default = "10.10.0.0/16"
}

variable instance_type {
    default = "t2.micro"
    }

variable server_list {
    type = map
    // default = toset (["Jenkins-master","Jenkins-slave","Ansible"])
    default = {
       server1 = {server = "jenkins-master" , os = "ubuntu"}
       server2 = {server = "jenkins-slave" , os ="ubuntu"}
       server3 = {server = "ansible" , os ="ubuntu"}

    }
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP access"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH access"
    }
  ]
}

variable "egress_rules"{
   type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
      }))

   default = [{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   },
   {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }
   ]
}