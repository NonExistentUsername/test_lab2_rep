# Державний вищий навчальний заклад Ужгородський національний університет Факультет інформаційних систем та технологій


# ЛАБОРАТОРНА РОБОТА №4
### Тема: Terraform.


Виконав студент 3 курсу
Напрям: ІСТ
Майор Дмитро


#### План:
- Створити один екземпляр (образ: ubuntu 20.04).
- Дозволити HTTP/HTTPS трафік на мережевій карті.
- Надання одного публічного ключа SSH для створеного екземпляру.
- Встановлення веб-сервера (Apache HTTP Server / NGINX HTTP Server) за допомогою сценарію bash.

### Виконання%
- Створити один екземпляр (образ: ubuntu 20.04).
  
  Створив файл labka.tf та додав в нього наступний код для підключення до AWS та створення екземпляру Ubuntu 20.04
  
  ```
  provider "aws" {
    access_key = ""
    secret_key = ""
    region = "eu-west-3"
  }

  resource "aws_instance" "ubuntu_instance" {
    count = 1
    ami = "ami-064736ff8301af3ee"
    instance_type = "t2.micro"
  }
  ```
- Дозволити HTTP/HTTPS трафік на мережевій карті.

  Додав наступні дві групи доступу на aws

  ```
  resource "aws_security_group" "https-group" {
      name        = "https-access-group"

      ingress {
          from_port = 443
          to_port   = 443
          protocol  = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
  }

  resource "aws_security_group" "http-group" {
      name        = "http-access-group"

      ingress {
          from_port = 80
          to_port   = 80
          protocol  = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
      }
  }
  ```
  
  Після цього, додав параметр vpc_security_group_ids до ubuntu_instance

  ```
    ...
    vpc_security_group_ids = [aws_security_group.http-group.id, aws_security_group.ssh-group.id]
    ...
  ```
  
- Надання одного публічного ключа SSH для створеного екземпляру.

  Додав наступну групу, щоб дозволити доступ по порту 22 для ssh підключень.
  ```
  resource "aws_security_group" "ssh-group" {
      name   = "ssh-access-group"

      egress = [
          {
              cidr_blocks      = [ "0.0.0.0/0", ]
              description      = ""
              from_port        = 0
              ipv6_cidr_blocks = []
              prefix_list_ids  = []
              protocol         = "-1"
              security_groups  = []
              self             = false
              to_port          = 0
          }
      ]
      ingress = [
          {
              cidr_blocks      = [ "0.0.0.0/0", ]
              description      = ""
              from_port        = 22
              ipv6_cidr_blocks = []
              prefix_list_ids  = []
              protocol         = "tcp"
              security_groups  = []
              self             = false
              to_port          = 22
          }
      ]
  }
  ```
  
  
