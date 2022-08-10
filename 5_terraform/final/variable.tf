variable "name_project" {
  description = "nombre de los proyectos"
  type= string
  default ="final_fer_"
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

variable "cidr_sb_priv1" {
  description = "cidr para la vpc"
  type = string
  default = "10.10.1.0/28"
}

variable "cidr_sb_priv2" {
  description = "cidr para la vpc"
  type = string
  default = "10.10.2.0/28"
}

variable "cidr_sb_pub1" {
  description = "cidr para la vpc"
  type = string
  default = "10.10.3.0/28"
}
variable "cidr_sb_pub2" {
  description = "cidr para la vpc"
  type = string
  default = "10.10.4.0/28"
}
