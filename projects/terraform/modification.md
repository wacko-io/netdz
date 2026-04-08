1 Я не нашел как реализован state-lock
![alt text](image.png)

2 не очень понял как реализована авторизация ВМ в ЯО

ВМ авторизуется в Yandex Cloud через attached service account и metadata service в main.tf (строка 20) и cloud-init.yaml (строка 87).