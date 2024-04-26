resource "aws_security_group" "Jenkins_SG" {
    name = "Jenkis_SecurityGroup"
    description = "Open 22,443,8080,9000,80"

    #Define a ingress/inbound rules to allow traffic
    ingress = [
        for port in [22,443,8080,9000,80,3000] : {
            description = "TLS from VPC"
            from_port = port
            to_port = port
            protocol = "tcp"
            cidr_blocks = [ "0.0.0.0/0" ]
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            security_groups = []
            self =false
        }
    ]

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    tags = {
        Name = "Jenkins_SG"
    }
  
}

resource "aws_instance" "Jenkins_server" {
    ami = "ami-007020fd9c84e18c7"
    instance_type = "t2.large"
    key_name = "DevSecOps-key"
    vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
    user_data = templatefile("./install_jenkins.sh", {})

    tags = {
      Name = "Jenkins-sonar"
    }

    root_block_device {
      volume_size = 30
    }
  
}