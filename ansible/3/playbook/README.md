# Ansible Playbook

## Что делает playbook

`site.yml` разворачивает стек из трёх сервисов на трёх группах хостов:

- `lighthouse-01`:
  устанавливает `nginx`, клонирует веб-интерфейс `Lighthouse` в `{{ lighthouse_location_dir }}` и раскладывает конфигурацию `nginx`.
- `clickhouse-01`:
  скачивает и устанавливает пакеты `ClickHouse`, настраивает прослушивание на всех интерфейсах, запускает сервис, создаёт базу `logs` и открывает порт `8123/tcp` в `firewalld`.
- `vector-01`:
  скачивает и распаковывает `Vector`, создаёт конфигурацию и systemd unit, после чего запускает сервис.

По умолчанию playbook использует inventory `inventory/prod.yml`, где заданы хосты:

- `clickhouse-01`
- `vector-01`
- `lighthouse-01`

## Запуск

```bash
ansible-playbook -i inventory/prod.yml site.yml
```

Проверка без изменений:

```bash
ansible-playbook -i inventory/prod.yml site.yml --check
```

## Параметры

### Общие переменные

Файл: `group_vars/all.yml`

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `ansible_user` | `yc-user` | пользователь для SSH-подключения |
| `ansible_ssh_private_key_file` | `~/.ssh/yc_ansible` | путь к приватному ключу |
| `ansible_become` | `yes` | выполнение задач с повышением привилегий |

### ClickHouse

Файл: `roles/clickhouse/defaults/main.yml`

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `clickhouse_version` | `22.3.3.44` | версия ClickHouse для установки |
| `clickhouse_packages` | список из `clickhouse-client`, `clickhouse-server`, `clickhouse-common-static` | набор RPM-пакетов и их архитектур |

Дополнительных group vars для группы `clickhouse` сейчас нет: `group_vars/clickhouse.yml` пустой.

### Vector

Файл: `roles/vector/defaults/main.yml`

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `vector_version` | `0.24.0` | версия Vector |
| `vector_arch` | `x86_64-unknown-linux-musl` | архитектура дистрибутива |
| `vector_archive` | `vector-{{ vector_version }}-{{ vector_arch }}.tar.gz` | имя архива |
| `vector_url` | `https://packages.timber.io/vector/{{ vector_version }}/{{ vector_archive }}` | URL для скачивания архива |
| `vector_release_dir` | `/opt/vector-{{ vector_version }}-{{ vector_arch }}` | каталог установленной версии Vector |

Файл: `group_vars/vector.yml`

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `clickhouse_host` | `clickhouse-01` | адрес ClickHouse для sink в Vector |
| `clickhouse_user` | `cl_admin` | пользователь для подключения к ClickHouse |
| `clickhouse_password` | `dgksk!ds)_dsg` | пароль для подключения к ClickHouse |

### Lighthouse

Файл: `roles/lighthouse/defaults/main.yml`

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `lighthouse_vsc` | `https://github.com/VKCOM/lighthouse.git` | Git-репозиторий Lighthouse |
| `lighthouse_location_dir` | `/usr/share/nginx/html/lighthouse` | каталог, в который клонируется Lighthouse |

Дополнительных group vars для группы `lighthouse` сейчас нет: `group_vars/lighthouse.yml` пустой.

### Nginx

Файл: `roles/nginx/defaults/main.yml`

| Переменная | Значение по умолчанию | Назначение |
| --- | --- | --- |
| `nginx_user_name` | `nginx` | пользователь в шаблоне `nginx.conf` |

Дополнительных group vars для группы `nginx` сейчас нет: `group_vars/nginx.yml` пустой.

## Теги

Явные теги в текущей версии playbook не заданы ни на уровне play, ни на уровне ролей, ни на уровне задач.

Это означает:

- `--tags` и `--skip-tags` не позволяют выбрать отдельные логические части развёртывания;
- для точечного запуска сейчас удобнее использовать `--limit` по хосту или группе.

Пример запуска только для Vector-хоста:

```bash
ansible-playbook -i inventory/prod.yml site.yml --limit vector-01
```

## Структура playbook

- `site.yml`:
  основной playbook с тремя play.
- `inventory/prod.yml`:
  inventory с целевыми хостами.
- `group_vars/all.yml`:
  общие переменные подключения.
- `group_vars/vector.yml`:
  переменные подключения Vector к ClickHouse.
- `roles/nginx`:
  установка `nginx`.
- `roles/lighthouse`:
  клонирование Lighthouse и раскладка конфигурации `nginx`.
- `roles/clickhouse`:
  установка и базовая настройка ClickHouse.
- `roles/vector`:
  установка и настройка Vector.
