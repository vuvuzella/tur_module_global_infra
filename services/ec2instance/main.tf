
// Read data-store/mysql's output data
// this is read-only. uncomment this when mysql module has been deployed
// data "terraform_remote_state" "db" {
//     backend = "s3"
//     config = {
//       // bucket    = "admin-dev-tf-state"
//       // key       = "stage/data-stores/mysql/terraform.tfstate"
//       bucket = "${var.db_remote_state_bucket}"
//       key = "${var.db_remote_state_key}"
//       region = "ap-southeast-2"
//       profile = "admin-dev"
//      }
// }

// Individual EC2 instance
// resource "aws_instance" "example" {
//     /*
//     ubuntu Server 20.04 LTS (HVM),
//     EBS General Purpose (SSD) Volume Type.
//     Support available from Canonical
//     */
//     ami = "ami-0567f647e75c7bc05"
//     // instance_type = terraform.workspace == "default" ? "t2.micro" : "t2.micro"   // choose value based on workspace
//     instance_type = "t2.micro"
//     tags = {
//         Name = "example"
//     }
//     // give ec2 instance a start script using heredoc
//     // use ${...} interpolation to inline scripts to parametarize the same stuff
//     // user_data = <<-EOF
//     //     #!/bin/bash
//     //     echo "Hello, World" >> index.html
//     //     echo "${data.terraform_remote_state.db.outputs.address}" >> index.html
//     //     echo "${data.terraform_remote_state.db.outputs.port}" >> index.html
//     //     nohup busybox httpd -f -p ${var.webserver_port} &
//     //     EOF
// 
//     // use externalized file instead
//     user_data = data.template_file.user_data.rendered
// 
//     // reference the security group by using resource attribute referemce
//     // <provider>_<type>.<name>.<attribute>
//     // this creates an implicit dependency
//     // vpc_security_group_ids = [data.aws_security_group.default_sg.id]
//     vpc_security_group_ids = [aws_security_group.ec2instance_example_sg.id]
// }
