provider "aws" {
    region = var.myregion
}
variable "myregion" {
    default = "us-east-1"
 }
variable "accountId" {
    default = "616649530907"
}