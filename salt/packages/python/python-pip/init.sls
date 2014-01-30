python-pip_install:
  file.managed:
    - name: /root/.pip/pip.conf
    - source: salt://packages/python/python-pip/pip.conf
    - user: root
    - group: root
    - mode: '0644'
  pkg.installed:
    - name: python-pip
    - require:
      - file: python-pip_install