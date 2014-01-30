uwsgi_startup:
  file.managed:
    - name: /etc/init/uwsgi.conf
    - source: salt://packages/uwsgi/files/uwsgi.upstart
    - user: root
    - group: root
    - mode: '0660'


uwsgi_install:
  user.present:
    - name: uwsgi
    - shell: /bin/false
    - home: /nonexistent
    - createhome: false
    - group: adm ## Group adm, so it can write logs.
  file.managed:
    - name: /etc/uwsgi/uwsgi.yaml
    - source: salt://packages/uwsgi/files/uwsgi.yaml.jinja
    - template: jinja
    - user: uwsgi
    - mode: '0660'
    - require:
      - user: uwsgi_install
  pip.installed:
    - name: uwsgi
    - require:
      - pkg: python-dev_install ## uWSGI will fail to comple without this.
      - pkg: python-pip_install ## So it can install via PIP
      - pkg: libcap-dev_install ## Needed to scope uWSGI to it's own user