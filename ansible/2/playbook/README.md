# ClickHouse and Vector Playbook

## Назначение

Playbook устанавливает и настраивает `ClickHouse` и `Vector` на хосте `rockylinux8`.

Сценарий состоит из двух play:

- `Install Clickhouse` скачивает RPM-пакеты ClickHouse, устанавливает их и создает базу данных `logs`.
- `Install Vector` скачивает архив Vector, распаковывает его в `/opt`, размещает конфигурацию в `/etc/vector/vector.yaml`, создает systemd unit и запускает сервис.

## Структура

- `site.yml` — основной playbook.
- `inventory/prod.yml` — inventory с группами `clickhouse` и `vector`.
- `group_vars/clickhouse/vars.yml` — переменные ClickHouse.
- `group_vars/vector/vars.yml` — переменные Vector.
- `templates/vector.yml.j2` — шаблон конфигурации Vector.

## Переменные

### ClickHouse

Файл: `group_vars/clickhouse/vars.yml`

- `clickhouse_version` — версия ClickHouse.
- `clickhouse_packages` — список RPM-пакетов для скачивания и установки.

Текущие значения:

```yaml
clickhouse_version: "22.3.3.44"
clickhouse_packages:
  - clickhouse-client
  - clickhouse-server
  - clickhouse-common-static
```

### Vector

Файл: `group_vars/vector/vars.yml`

- `vector_version` — версия Vector.
- `vector_arch` — архитектура архива.
- `vector_archive` — имя скачиваемого архива.
- `vector_url` — URL архива.
- `vector_release_dir` — каталог распакованной версии Vector.

Текущие значения:

```yaml
vector_version: "0.24.0"
vector_arch: "x86_64-unknown-linux-musl"
vector_archive: "vector-{{ vector_version }}-{{ vector_arch }}.tar.gz"
vector_url: "https://packages.timber.io/vector/{{ vector_version }}/{{ vector_archive }}"
vector_release_dir: "/opt/vector-{{ vector_version }}-{{ vector_arch }}"
```

## Inventory

Playbook использует файл `inventory/prod.yml`.

В текущей конфигурации обе группы указывают на один и тот же Docker-хост:

```yaml
clickhouse:
  hosts:
    rockylinux8:
      ansible_connection: docker

vector:
  hosts:
    rockylinux8:
      ansible_connection: docker
```

## Что делает playbook

### ClickHouse

1. Скачивает `clickhouse-client` и `clickhouse-server` как `noarch.rpm`.
2. Пытается скачать `clickhouse-common-static` как `noarch.rpm`.
3. При ошибке `404` в блоке `rescue` скачивает `clickhouse-common-static` как `x86_64.rpm`.
4. Устанавливает RPM-пакеты из `/tmp`.
5. Перезапускает сервис `clickhouse-server`.
6. Создает базу данных `logs`.

### Vector

1. Создает директории `/opt`, `/etc/vector`, `/var/lib/vector`.
2. Скачивает архив Vector в `/tmp`.
3. Распаковывает архив в `/opt`.
4. Разворачивает конфигурацию из шаблона `templates/vector.yml.j2`.
5. Создает unit-файл `/etc/systemd/system/vector.service`.
6. Перезапускает или запускает сервис `vector`.

## Handlers

Используются два обработчика:

- `Start clickhouse service`
- `Restart vector`

Handler `Restart vector` вызывается при изменении конфигурации Vector и при изменении unit-файла сервиса.

## Теги

В текущей версии playbook теги не заданы.

## Запуск

Проверка без внесения изменений:

```bash
ansible-playbook site.yml -i inventory/prod.yml --check
```

Запуск с выводом diff:

```bash
ansible-playbook site.yml -i inventory/prod.yml --diff
```

Повторный запуск для проверки идемпотентности:

```bash
ansible-playbook site.yml -i inventory/prod.yml --diff
```

## Особенности

- Для ClickHouse используется установка из RPM-файлов, скачанных через `get_url`.
- Для Vector используется установка из архива через `get_url` и `unarchive`.
- Конфигурация Vector разворачивается через шаблон `templates/vector.yml.j2`.
- В текущем шаблоне Vector отправляет данные в ClickHouse по адресу `http://localhost:8123`.
