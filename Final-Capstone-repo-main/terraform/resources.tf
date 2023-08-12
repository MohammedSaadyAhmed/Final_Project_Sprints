resource "aws_vpc" "my-instance" {
    cidr_block = "10.0.0.0/16"
    tags = {
        "Name"= "my-instance"
        project= "sprints-project"
    }
}
resource "aws_subnet" "tf_subnet1" {
    cidr_block = "10.0.0.0/24"
    vpc_id = aws_vpc.my-instance.id
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
     tags = {
        Name = "tf_subnet1"
    }
}
resource "aws_subnet" "tf_subnet2" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my-instance.id
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
     tags = {
        Name = "tf_subnet2"
    }
}
resource "aws_internet_gateway" "tf_IGW" {
  vpc_id = aws_vpc.my-instance.id
    tags = {
    Name = "tf_IGW"
  }
}
resource "aws_route_table" "tf_routeTable" {
  vpc_id = aws_vpc.my-instance.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_IGW.id
  }
   tags = {
    Name = "tf_routeTable"
  }
}
resource "aws_route_table_association" "tf_routeTable_association1" {
  subnet_id      = aws_subnet.tf_subnet1.id
  route_table_id = aws_route_table.tf_routeTable.id
}
resource "aws_route_table_association" "tf_routeTable_association2" {
  subnet_id      = aws_subnet.tf_subnet2.id
  route_table_id = aws_route_table.tf_routeTable.id
}
resource "aws_security_group" "tf_securityGroup" {
  name        = "tf_securityGroup"
  description = "Allow HTTP and SSH traffic"
  vpc_id = aws_vpc.my-instance.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTPS connections"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all incoming traffic"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  tags = {
    Name = "tf_securityGroup"
  }
}
resource "aws_eks_node_group" "eks_group" {
  cluster_name    = aws_eks_cluster.jenkins.name
  node_group_name = "new-eks-group"
  node_role_arn   = aws_iam_role.eks_roles.arn
  subnet_ids      = [aws_subnet.tf_subnet1.id, aws_subnet.tf_subnet2.id]  

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 2
  }
}
resource "aws_iam_role" "eks_roles" {
  name = "eks_roles"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_roles.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_roles.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_roles.name
}
