1
![alt text](./images/image-16.png)
![alt text](./images/image-14.png)
![alt text](./images/image-13.png)
![alt text](./images/image-3.png)
![alt text](./images/image-4.png)
![alt text](./images/image-5.png)

2

![alt text](./images/image-17.png)
![alt text](./images/image-18.png)
![alt text](./images/image-19.png)

3
![alt text](./images/image-9.png)

4

получил пароль для бд из локбокса
```
yc lockbox payload get --name terraform-project-mysql-password
```
подключился к ВМ, создал .env, вписал туда данные для бд
```
DB_HOST=rc1a-6tcgt8uu2qft626a.mdb.yandexcloud.net
DB_USER=terraform-project-admin
DB_PASSWORD=O0bXZRoEpu3oPvu6
DB_NAME=terraform-project-mysql-db
DB_SSL_CA=/home/python/.mysql/root.crt
```
написал compose.yml (пример в /docker) и запустил docker compose up -d (если первое подключение на сервере, то нужно сначала сделать newgrp docker для обновления групп)
![alt text](./images/image33.png)

5
![alt text](./images/image-8.png)

Чек-лист
![alt text](./images/image-15.png)
изменил в default.conf proxy_pass http://web:5000; и закинул оба конфига на сервер
![alt text](./images/image-12.png)
![alt text](./images/image01.png)
![alt text](./images/image-11.png)

После завершения работы над проектом использовал terraform destroy