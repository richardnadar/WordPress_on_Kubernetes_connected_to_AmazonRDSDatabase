provider "kubernetes" {
  config_context = "minikube"
}

provider "aws" {
  region  = "ap-south-1"
  profile = "richie"
}

resource "kubernetes_deployment" "wordpressdeploy" {
 metadata {
 name = "wordpress"
 labels = {
 env = "testing"
 }
 }
 spec {
 selector {
 match_labels = {
 env = "testing"
 }
 }
 template {
 metadata {
 labels = {
 env = "testing"
 }
 }
 spec {
 container {
 image = "wordpress:latest"
 name = "wordpress"
 }
 }
 }
 }
 }

resource "kubernetes_service" "wp_service" {
 metadata {
 name = "wordpress"
 }
 spec {
 selector = {
 env = "testing"
 }
 session_affinity = "ClientIP"
 port {
 port = 80
 target_port = 80
 }
 type = "NodePort"
 }
}

resource "aws_db_instance" "richrds" {
 allocated_storage = 20
 storage_type = "gp2"
 engine = "mysql"
 engine_version = "8.0.20"
 instance_class = "db.t2.micro"
 name = "richard"
 username = "root"
 password = "abdsftyus"
 parameter_group_name = "default.mysql8.0"
 skip_final_snapshot = "true"
 publicly_accessible = "true"
 port = "3306"
}


output "Database_endPoint" {
 value = aws_db_instance.richrds.endpoint
}