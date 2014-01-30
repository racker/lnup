beaver_install:
  user.present:
    - name: beaver
    - shell: /bin/false
    - createhome: True
    - group: adm
  pip.installed:
    - name: beaver=={{ pillar['beaver']['version'] }}
    - require:
      - pkg: python-pip_install ## So it can install via PIP
  file.managed:
    - name: /etc/init/beaver.conf
    - source: salt://packages/beaver/files/beaver.upstart.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0640'