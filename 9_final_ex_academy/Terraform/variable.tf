variable "name_project" {
  description = "nombre de los proyectos"
  type= string
  default ="final_g2_test"
}
variable "key_name" {
  description = "SSH pair keys"
  default = "ac_xl_pract_ssh"

}
variable "cidrvpc" {
  description = "cidr para la vpc"
  type = string
  default = "10.10.0.0/16"
}

variable "cidr_sb_priv" {
  description = "cidr para la sb priv"
  type = string
  default = "10.10.1.0/28"
}

variable "cidr_sb_pub" {
  description = "cidr para la pub"
  type = string
  default = "10.10.2.0/28"
}

locals {
  key_path= "key.pem"
}

