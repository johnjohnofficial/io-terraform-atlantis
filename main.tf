## https://www.terraform.io/docs/providers/aws/index.html
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-2"
  access_key = "AKIAXHYNDXQYF7AKVRDT"
  secret_key = "q+jLRCR/bISeAsm3yX0q1ee6G8GjVcNkqyiZStsy"
}

## https://www.terraform.io/docs/providers/aws/r/instance.html
resource "aws_instance" "sample" {
  ami           = "ami-02ed481668fbb20fd"
  instance_type = "t2.medium"  ## https://aws.amazon.com/pt/ec2/instance-types/
}

output "dns_public" {
  value = "${aws_instance.sample.public_dns}"
}