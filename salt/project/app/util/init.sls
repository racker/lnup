include:
  ## Beaver
  - packages.beaver.beaver_config
  ## Newrelic Plugin Agent Monitoring
  - packages.newrelic_plugin_agent.newrelic-plugin-agent-monitor
  ## NGINX Config
  - packages.nginx.nginx_config
  ## NGINX Maintenance Page
  - packages.nginx.nginx_maintenance_page


util-beavered-logs:
  file.accumulated:
    - filename: /etc/beaver.conf
    - name: beaverd-logs-accumulated
    - text: |-
        [/var/log/barman/*]
        sincedb_write_interval: 3
        type: barman
    - require_in:
      - file: beaver_config


util-newrelic-plugin-agent-monitor_conf:
  file.accumulated:
    - filename: /etc/newrelic/newrelic_plugin_agent.cfg
    - name: newrelic-plugin-agent-monitor
    - text: |-
        elasticsearch:
            name: {{ grains['host'] }}
            host: localhost
            port: 9200
    - require_in:
      - file: newrelic-plugin-agent-monitor_config


## Kibana
kibana_config:
  file.managed:
    - name: /opt/kibana/config.js
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/config.js.jinja
    - template: jinja
    - user: www-data
    - group: nogroup
    - mode: '0644'
    - require:
      - pkg: nginx_install
    - require_in:
      - git: kibana_install


## NGINX
nginx_kibana_vhost:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/nginx_kibana_vhost.conf.jinja
    - template: jinja
    - makedirs: True
    - user: root
    - group: root
    - mode: '0644'
    - require_in:
      - service: nginx_install


## Logstash
logstash_config:
  file.managed:
    - name: /etc/logstash_indexer.conf
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/logstash_indexer.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'
    - require_in:
      - file: logstash_install
  service.running:
    - name: logstash
    - watch:
      - file: logstash_config
      - file: logstash_install


## Barman
{% for backup_dirs in ["/var/lib/barman/" + pillar['project_name']+ "/incoming", "/var/lib/barman/" + pillar['project_name']+ "/base", "/var/lib/barman/" + pillar['project_name'] + "/wals"] %}
{{ backup_dirs }}:
  file.directory:
    - makedirs: True
    - user: barman
    - group: barman
    - require:
      - pkg: barman_install
      - pkg: postgresql-client-common_install
{% endfor %}


barman_ssh_private_dir:
  file.directory:
    - name: /var/lib/barman/.ssh
    - makedirs: True
    - user: barman
    - group: barman
    - require:
      - pkg: barman_install
      - pkg: postgresql-client-common_install


barman_ssh_private_file:
  file.managed:
    - name: /var/lib/barman/.ssh/id_rsa
    - mode: '0600'
    - user: barman
    - group: barman
    - source: salt://project/{{ pillar['project_name'] }}/common/files/ssh_private_key.jinja
    - template: jinja
    - require:
      - file: barman_ssh_private_dir


postgres_ssh_public:
  ssh_auth.present:
    - user: barman
    - enc: ssh-rsa
    - names:
      - {{ pillar['ssh']['public']['postgres'] }}
    - require:
      - file: barman_ssh_private_file


barman_config:
  file.managed:
    - name: /etc/barman.conf
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/barman.conf.jinja
    - template: jinja
    - require_in:
      - pkg: barman_install