0. ![img.png](img.png)
1. ![img_1.png](img_1.png)![img_2.png](img_2.png)![img_3.png](img_3.png)
2. ![img_4.png](img_4.png)
3. не понял, как я должен был делать curl к 8090 порту, если в proxy.yaml прокинуты 8080, т.к указано что начальные файлы редактировать запрещено, сделал курл к 8080 получил время и ошибку про IP, но таблица создалась![img_5.png](img_5.png)
4. был удивлен, что если обращаться к 8090 порту контейнера, который поднят на сервере, то все проходит успешно, хотя в конфиге все еще 8080 прокинут![img_6.png](img_6.png) https://github.com/wacko-io/shvirtd-example-python
5.
```
#!/bin/bash
set -euo pipefail

cd /opt/shvirtd-example-python

set -a
source /opt/shvirtd-example-python/.env
set +a

mkdir -p /opt/backup
timestamp=$(date +%Y%m%d_%H%M%S)
docker run --rm --network shvirtd-example-python_backend mysql:8.0 mysqldump -h db -u root -p"$MYSQL_ROOT_PASSWORD" --all-databases > /opt/backup/backup_${timestamp}.sql
```
```
*/1 * * * * /opt/shvirtd-example-python/backup.sh
```
![img_7.png](img_7.png)
6. ![img_9.png](img_9.png)![img_10.png](img_10.png)![img_11.png](img_11.png)
6.1 ![img_12.png](img_12.png)
6.2
```
FROM hashicorp/terraform:latest AS source
FROM scratch
COPY --from=source /bin/terraform /
```
![img_13.png](img_13.png)
7. ![img_14.png](img_14.png)