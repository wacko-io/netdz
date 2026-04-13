Role Name
=========

The role install vector

Role Variables
--------------

```
vector_version
some_host
some_user
some_password
```

Example Playbook
----------------

```
- name: Install Vector
  hosts: vector-01
  become: true
  roles:
    - vector-role
```

License
-------

MIT

Author Information
------------------

Matveev Dmitriy