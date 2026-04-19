Role Name
=========

The role install and configurate nginx

Role Variables
--------------

```nginx_user_name```

Example Playbook
----------------

- name: Install Nginx
  hosts: lighthouse
  become: true
  roles:
    - nginx

License
-------

MIT

Author Information
------------------

Matveev Dmitriy
