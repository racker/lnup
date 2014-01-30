maintenance_page:
  file.managed:
    - name: /etc/nginx/error_pages/maintenance.html
    - source: salt://packages/nginx/files/maintenance.html
    - mode: '0644'
    - require_in:
      - service: nginx_install