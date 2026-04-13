Role Name
=========

The role install lighthouse with configuration nginx

Dependencies
------------

```
src: git@github.com:wacko-io/ansible-role-nginx.git
version: "1.0.0'
```

Example Playbook
----------------

```
- name: Install Nginx and Lighthouse
  hosts: lighthouse-01
  become: true
  roles:
    - nginx
    - lighthouse
```

License
-------

MIT

Author Information
------------------

Matveev Dmitriy
