nginx_install:
  pkgrepo.managed:
    - ppa: nginx/stable
  pkg.installed:
    - name: nginx-extras
  file.managed:
    - name: /etc/init/nginx.conf
    - source: salt://packages/nginx/files/nginx.upstart
    - user: root
    - group: root
    - mode: '0640'
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: nginx_install