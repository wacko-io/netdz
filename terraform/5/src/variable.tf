variable "cloud_id" {
    type = string
}
variable "folder_id" {
    type = string
}
variable "default_zone" {
    type = string
    default = "ru-central1-a"
}

variable "check_ip_correct" {
  type = string
  description = "ip-адрес — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex()"
  default = "192.168.0.1"
  validation {
    condition = can(cidrhost("${var.check_ip_correct}/32", 0))
    error_message = "Значение '${var.check_ip_correct}' не является корректным IPv4 адресом."
  }
}

variable "ip_whitelist" {
  description = "Список IP-адресов для белого списка"
  type        = list(string)
  default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]

  validation {
    condition = alltrue([
      for ip in var.ip_whitelist : can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ip))
    ])
    error_message = "IP address должны быть валидны"
  }
}

variable "downer"{
    type = string
    default = "wacko"
    description = "Строка, содержащая только строчные буквы"
    validation {
        condition = can(regex("^[a-z]+$", var.downer))
        error_message = "Значение '${var.downer}' должно содержать только строчные буквы."
    }
}

variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = false
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = var.in_the_end_there_can_be_only_one.Dunkan != var.in_the_end_there_can_be_only_one.Connor
        
    }
}