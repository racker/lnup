{%- set postgres_compound_string = "G@node_type:postgres and G@datacenter:" +  grains['datacenter'] + " and G@env:" + grains['env'] -%}
{%- set redis_compound_string = "G@node_type:redis and G@datacenter:" +  grains['datacenter'] + " and G@env:" + grains['env'] -%}
include:
  ## Beaver
  - packages.beaver.beaver_config
  ## Newrelic Plugin Agent Monitoring
  - packages.newrelic_plugin_agent.newrelic-plugin-agent-monitor
  ## Application User
  - project.{{ pillar['project_name'] }}.common.app_user


web-beavered-logs:
  file.accumulated:
    - filename: /etc/beaver.conf
    - name: beaverd-logs-accumulated
    - text: |-
        [/var/log/celery/*.log]
        sincedb_write_interval: 3
        type: celery
    - require_in:
      - file: beaver_config


web-newrelic-plugin-agent-monitor_conf:
  file.accumulated:
    - filename: /etc/newrelic/newrelic_plugin_agent.cfg
    - name: newrelic-plugin-agent-monitor
    - text: |-
        uwsgi:
            name: {{ grains['host'] }}
            path: /tmp/{{ pillar['project_name'] }}_stats.socket
    - require_in:
      - file: newrelic-plugin-agent-monitor_config


## LDAP
ldap_conf:
  file.managed:
    - name: /etc/openldap/ldap.conf
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/ldap.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: python-ldap_install


## New Relic application monitoring
newrelic_app_config:
  file.managed:
    - name: {{ pillar['document_root'] }}/{{ pillar['project_name'] }}/newrelic.ini
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/newrelic.ini.jinja
    - template: jinja
    - user: {{ pillar['project_name'] }}
    - group: nogroup
    - mode: '0664'
    - require:
      - user: app_user


## uWSGI
uwsgi_app_vhost:
  file.managed:
    - name:  {{ pillar['document_root'] }}/{{ pillar['project_name'] }}/{{ pillar['project_name'] }}.yaml
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/uwsgi_app_vhost.yaml.jinja
    - template: jinja
    - user: {{ pillar['project_name'] }}
    - group: www-data
    - mode: '0644'
    - require:
      - user: app_user
    - require_in:
      - service: uwsgi_install
      - virtualenv: app_install
  service.running:
    - name: uwsgi
    - watch:
      - git: app_install
    - require:
      - file: uwsgi_startup
    - require_in:
      - service: uwsgi_install


uwsgi_app_envs:
  file.accumulated:
    - filename: {{ pillar['document_root'] }}/{{ pillar['project_name'] }}/{{ pillar['project_name'] }}.yaml
    - name: uwsgi-envvars-accumulated
    - text:
      - "env: DB_ENGINE={{ pillar['database_engine'] }}"
      - "env: DB_NAME={{ pillar['database_name'] }}"
      - "env: DB_USER={{ pillar['database_user'] }}"
      - "env: DB_PASS={{ pillar['database_password'] }}"
      - "env: DB_HOST={{ salt['publish.publish']( postgres_compound_string, 'network.ip_addrs', 'eth0', expr_form='compound').values()[0][0] }}"
      - "env: DB_PORT={{ pillar['database_port'] }}"
      - "env: SECRET_KEY={{ pillar['secret_key'] }}"
      - "env: REDISIP={{ salt['publish.publish']( redis_compound_string, 'network.ip_addrs', 'eth0', expr_form='compound').values()[0][0] }}"
      - "env: POSTGRESIP={{ salt['publish.publish']( postgres_compound_string, 'network.ip_addrs', 'eth0', expr_form='compound').values()[0][0] }}"
      - "env: DJANGO_SETTINGS_MODULE=%n.settings.production"
      - "env: LC_ALL='en_US.UTF-8'"
      - "env: LANG='en_US.UTF-8'"
    - require_in:
      - file: uwsgi_app_vhost


app_envs:
  file.append:
    - name: /etc/environment
    - text:
      - NEW_RELIC_ENVIRONMENT="{{ grains['newrelic_env'] }}"
  cmd.wait:
    - name: while read -r env; do export "$env"; done
    - watch:
      - file: app_envs


## Application
app_install:
  file.directory:
    - name: {{ pillar['document_root'] }}/.virtualenvs/
    - owner: {{ pillar['project_name'] }}
    - group: www-data
    - require:
      - user: app_user
  git.latest:
    - name: {{ pillar['git_url'] }}
    - rev: {{ pillar['branch_or_tag'] }}
    - target: {{ pillar['document_root'] }}/{{ pillar['project_name'] }}/{{ pillar['project_name'] }}-repo
    - user: {{ pillar['project_name'] }}
    - force: True
    - require:
      - file: app_install
      - pkg: git_install
  virtualenv.managed:
    - name: {{ pillar['document_root'] }}/.virtualenvs/{{ pillar['project_name'] }}
    - no_site_packages: True
    - user: {{ pillar['project_name'] }}
    - cwd: {{ pillar['document_root'] }}/{{ pillar['project_name'] }}/{{ pillar['project_name'] }}-repo
    - requirements: {{ pillar['document_root'] }}/{{ pillar['project_name'] }}/{{ pillar['project_name'] }}-repo/requirements.txt
    - require:
      - git: app_install
      - pip: python-virtualenv_install
      - pkg: python-dev_install
      - pkg: libldap2-dev_install
      - pkg: libsasl2-dev_install
      - pkg: libssl-dev_install
      - pkg: python-pip_install
      - pkg: python-ldap_install
      - pkg: libpq-dev_install
      - file: newrelic_app_config
      - file: ldap_conf


## Celery
celery_default_config:
  file.managed:
    - name: /etc/default/celeryd
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/celeryd.default.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - file: celery_logfile


celery_init_config:
  file.managed:
    - name: /etc/init.d/celeryd
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/celeryd.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0740'
    - require:
      -  file: celery_default_config
  service.running:
    - name: celeryd
    - watch:
      - git: app_install


celery_logs:
  file.directory:
    - name: /var/log/celery
    - user: {{ pillar['project_name'] }}
    - group: adm
    - mode: '0755'
    - makedirs: True
    - require:
      - user: app_user


celery_logfile:
  file.managed:
    - name: /var/log/celery/w1.log
    - user: {{ pillar['project_name'] }}
    - group: adm
    - mode: '0640'
    - require:
      - file: celery_logs