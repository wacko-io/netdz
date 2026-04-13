# Ansible Playbook

Playbook из этого каталога разворачивает связку `ClickHouse + Vector + Nginx + Lighthouse` на трёх хостах из `inventory/prod.yml`.

## Состав

`site.yml` содержит 3 play:

- `lighthouse-01`:
  запускает роли `nginx` и `lighthouse`.
- `clickhouse-01`:
  запускает роль `clickhouse`.
- `vector-01`:
  запускает роль `vector-role`.

Inventory разбит на 3 группы:

- `clickhouse`
- `vector`
- `lighthouse`

В текущем `inventory/prod.yml` заданы хосты:

- `clickhouse-01`
- `vector-01`
- `lighthouse-01`

## Что делает каждая роль

### `nginx`

Роль устанавливает:

- `epel-release`
- `nginx`

После установки вызывает handler запуска `nginx`.

### `lighthouse`

Роль:

- устанавливает `git`
- клонирует `https://github.com/VKCOM/lighthouse.git` в `{{ lighthouse_location_dir }}`
- раскладывает основной конфиг `nginx` из шаблона `templates/nginx.conf.j2`

### `clickhouse`

Используется роль `clickhouse`, подключённая как локальный каталог `clickhouse/`.

Она:

- подбирает переменные под ОС
- проверяет поддерживаемую платформу
- устанавливает ClickHouse через пакетный менеджер
- применяет системную конфигурацию
- запускает сервис
- ждёт готовности TCP-порта
- при необходимости создаёт БД и словари

В `site.yml` для неё не задано дополнительных параметров, поэтому используются значения роли по умолчанию.

### `vector-role`

Роль:

- создаёт каталоги `/opt`, `/etc/vector`, `/var/lib/vector`
- скачивает архив Vector
- распаковывает его в `/opt`
- раскладывает конфиг `/etc/vector/vector.conf`
- создаёт systemd unit `vector.service`
- запускает и включает сервис

Шаблон `templates/vector.conf.j2` отправляет demo syslog-события в ClickHouse на `http://{{ clickhouse_host }}:8123`.

## Переменные

### Общие

Файл: `group_vars/all.yml`

| Переменная | Значение |
| --- | --- |
| `ansible_user` | `yc-user` |
| `ansible_ssh_private_key_file` | `~/.ssh/yc_ansible` |
| `ansible_become` | `yes` |

### Vector

Файл: `group_vars/vector.yml`

| Переменная | Значение |
| --- | --- |
| `clickhouse_host` | `clickhouse-01` |
| `clickhouse_user` | `cl_admin` |
| `clickhouse_password` | `dgksk!ds)_dsg` |

Файл: `vector-role/defaults/main.yml`

| Переменная | Значение |
| --- | --- |
| `vector_version` | `0.24.0` |
| `some_host` | `clickhouse` |
| `some_user` | `user` |
| `some_password` | `password` |

Файл: `vector-role/vars/main.yml`

| Переменная | Значение |
| --- | --- |
| `vector_arch` | `x86_64-unknown-linux-musl` |
| `vector_archive` | `vector-{{ vector_version }}-{{ vector_arch }}.tar.gz` |
| `vector_url` | `https://packages.timber.io/vector/{{ vector_version }}/{{ vector_archive }}` |
| `vector_release_dir` | `/opt/vector-{{ vector_version }}-{{ vector_arch }}` |

### Lighthouse

Файл: `lighthouse/vars/main.yml`

| Переменная | Значение |
| --- | --- |
| `lighthouse_vsc` | `https://github.com/VKCOM/lighthouse.git` |
| `lighthouse_location_dir` | `/usr/share/nginx/html/lighthouse` |

### Nginx

Файл: `nginx/defaults/main.yml`

| Переменная | Значение |
| --- | --- |
| `nginx_user_name` | `nginx` |

### ClickHouse

Файл: `clickhouse/defaults/main.yml`

Ключевые значения по умолчанию, которые реально влияют на этот playbook:

| Переменная | Значение |
| --- | --- |
| `clickhouse_version` | `latest` |
| `clickhouse_service_ensure` | `started` |
| `clickhouse_service_enable` | `true` |
| `clickhouse_http_port` | `8123` |
| `clickhouse_tcp_port` | `9000` |
| `clickhouse_setup` | `package` |
| `clickhouse_remove` | `false` |

Файл: `clickhouse/vars/main.yml`

| Переменная | Значение |
| --- | --- |
| `clickhouse_package` | `clickhouse-client`, `clickhouse-server`, `clickhouse-common-static` |
| `clickhouse_path_configdir` | `/etc/clickhouse-server` |
| `clickhouse_path_logdir` | `/var/log/clickhouse-server` |
| `clickhouse_service` | `clickhouse-server.service` |

Дополнительных настроек в `group_vars/clickhouse.yml`, `group_vars/lighthouse.yml` и `group_vars/nginx.yml` сейчас нет.

## Подготовка

Роли уже лежат в репозитории как локальные каталоги:

- `clickhouse/`
- `nginx/`
- `lighthouse/`
- `vector-role/`

Файл `requirements.yml` можно использовать для переустановки или обновления ролей из исходных репозиториев:

```bash
ansible-galaxy install -r requirements.yml -p .
```

Важно: в `requirements.yml` используются SSH URL вида `git@github.com:...`, поэтому для этой команды нужен доступ к GitHub по SSH.

## Запуск

Основной запуск:

```bash
ansible-playbook -i inventory/prod.yml site.yml
```

Проверка без изменений:

```bash
ansible-playbook -i inventory/prod.yml site.yml --check
```

Проверка синтаксиса:

```bash
ansible-playbook -i inventory/prod.yml site.yml --syntax-check
```

Теги явно есть только внутри роли `clickhouse`:

- `always`
- `install`
- `config`
- `config_sys`
- `config_db`
- `config_dict`
- `remove`

Для остальных ролей отдельные теги не заведены, поэтому для точечного запуска удобнее использовать `--limit`.

Пример запуска только для `vector-01`:

```bash
ansible-playbook -i inventory/prod.yml site.yml --limit vector-01
```

## Структура каталога

- `site.yml`:
  основной playbook.
- `inventory/prod.yml`:
  inventory с тремя целевыми хостами.
- `group_vars/`:
  общие и групповые переменные.
- `clickhouse/`:
  роль установки и настройки ClickHouse.
- `nginx/`:
  роль установки Nginx.
- `lighthouse/`:
  роль установки Lighthouse и раскладки конфига Nginx.
- `vector-role/`:
  роль установки и настройки Vector.
- `requirements.yml`:
  источники ролей для `ansible-galaxy`.
