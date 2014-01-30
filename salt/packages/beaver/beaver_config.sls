## Beaver
beaver_config:
  file.managed:
    - name: /etc/beaver.conf
    - source: salt://packages/beaver/files/beaver.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require_in:
      - pip: beaver_install
  service.running:
    - name: beaver
    - watch:
      - file: beaver_config