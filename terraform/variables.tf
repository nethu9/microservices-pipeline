variable "region" {
  default = "us-east-1"
}

variable "workers" {
  default = 2
}

variable "ami" {
  default = "ami-09e6f87a47903347c"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "k8s-key-path" {
  default = "k8s-key.pub"
}

variable "k8s-key" {
  default = "k8s-key"
}

variable "runner_instance_type" {
  default = "ami-05ffe3c48a9991133"
}