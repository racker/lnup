{%- set util_compound_string = "G@node_type:util and G@datacenter:" +  grains['datacenter'] + " and G@env:" + grains['env'] -%}
include:
  ## Beaver
  - packages.beaver.beaver_config
  ## Newrelic Plugin Agent Monitoring
  - packages.newrelic_plugin_agent.newrelic-plugin-agent-monitor
  ## Application User
  - project.{{ pillar['project_name'] }}.common.app_user


postgres-beavered-logs:
  file.accumulated:
    - filename: /etc/beaver.conf
    - name: beaverd-logs-accumulated
    - text: |-
        [/var/log/postgresql/*]
        sincedb_write_interval: 3
        type: postgres
    - require_in:
      - file: beaver_config


postgres-newrelic-plugin-agent-monitor_conf:
  file.accumulated:
    - filename: /etc/newrelic/newrelic_plugin_agent.cfg
    - name: newrelic-plugin-agent-monitor
    - text: |-
        postgresql:
            host: localhost
            port: 5432
            user: {{ pillar['database_user'] }}
            dbname: {{ pillar['database_name'] }}
            password: {{ pillar['database_password'] }}
            superuser: false
    - require_in:
      - file: newrelic-plugin-agent-monitor_config


postgres_ssh_private_dir:
  file.directory:
    - name: /var/lib/postgresql/.ssh
    - makedirs: True
    - user: postgres
    - group: postgres
    - mode: '0700'
    - require:
      - pkg: postgres_install


postgres_ssh_private:
    file.managed:
      - name: /var/lib/postgresql/.ssh/id_rsa
      - mode: '0600'
      - user: postgres
      - group: postgres
      - source: salt://project/{{ pillar['project_name'] }}/common/files/ssh_private_key.jinja
      - template: jinja
      - require:
        - pkg: postgres_install
        - file: postgres_ssh_private_dir


barman_ssh_public:
  ssh_auth.present:
    - user: postgres
    - group: postgres
    - enc: ssh-rsa
    - names:
      - {{ pillar['ssh']['public']['barman'] }}
    - require:
      - pkg: postgres_install
      - file: postgres_ssh_private_dir


barman_public_ssh_fingerprint:
  ssh_known_hosts.present:
    - name: {{ salt['publish.publish']( util_compound_string, 'network.ip_addrs', 'eth0', expr_form='compound').values()[0][0] }}
    - user: postgres
    - config: /var/lib/postgresql/.ssh/known_hosts
    - enc: ssh-rsa
    - require:
      - pkg: postgres_install
      - file: postgres_ssh_private_dir


app_database_user:
  postgres_user.present:
    - name: {{ pillar['database_user'] }}
    - password: {{ pillar['database_password'] }}
    - user: postgres
    - require:
      - pkg: postgres_install
      - user: app_user


app_database:
  postgres_database.present:
    - template: template0
    - name: {{ pillar['database_name'] }}
    - owner: {{ pillar['database_user'] }}
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - encoding: UTF8
    - user: postgres
    - require:
      - postgres_user: app_database_user


app_hba:
  file.managed:
    - name: /etc/postgresql/9.2/main/pg_hba.conf
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/pg_hba.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - require:
      - pkg: postgres_install
  service.running:
    - name: postgresql
    - watch:
      - file: app_hba


postgres_config:
  file.managed:
    - name: /etc/postgresql/9.2/main/postgresql.conf
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/postgresql.conf.jinja
    - template: jinja
    - user: postgres
    - group: postgres
    - require:
      - pkg: postgres_install
  service.running:
    - name: postgresql
    - watch:
      - file: postgres_config