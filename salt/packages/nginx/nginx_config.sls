nginx_config:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://packages/nginx/files/nginx.conf
    - user: root
    - group: root
    - mode: '0644'
    - require_in:
      - service: nginx_install
  service.running:
    - name: nginx
    - watch:
      - file: nginx_config
    - require_in:
      - service: nginx_install