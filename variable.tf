variable "ports" {
    type=list(number)
    
  
}
variable "cidr_block" {
    type = list(string)
    
  
}
variable "instance" {
    type = string
    
  
}
variable "ami" {
    type = list(string)
    
}
variable "bkname" {
  
  type=string
}
variable "keyName" {
    type= string
  
}