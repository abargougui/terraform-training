# Provider configuration 
provider "aws" {
  region = "${var.region}"
}

# Resource configuration 
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name  = "main"
    Topic = "Tarraform Training"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = "${aws_vpc.my_vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Topic = "Tarraform Training"
  }
}

resource "aws_instance" "master-instance" {
  ami           = "ami-2cf54551"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public.id}"

  tags {
    Topic = "Tarraform Training"
  }
}

resource "aws_instance" "slave-instance" {
  ami           = "ami-2cf54551"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.public.id}"
  depends_on    = ["aws_instance.master-instance"]

  lifecycle {
    ignore_changes = ["tags"]
  }

  tags {
    Topic = "Tarraform Training"
  }
}

module "mighty_trousers" {
  source      = "./modules/application"
  vpc_id      = "${aws_vpc.my_vpc.id}"
  subnet_id   = "${aws_subnet.public.id}"
  name        = "MightyTrousers"
  environment = "${var.environment}"
}

module "crazy_foods" {
  source    = "./modules/application"
  vpc_id    = "${aws_vpc.my_vpc.id}"
  subnet_id = "${aws_subnet.public.id}"
  name      = "CrazyFoods ${module.mighty_trousers.hostname}"
}
