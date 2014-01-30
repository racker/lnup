include:
  ## Beaver
  - packages.beaver.beaver_config
  ## Newrelic Plugin Agent Monitoring
  - packages.newrelic_plugin_agent.newrelic-plugin-agent-monitor
  ## NGINX Config
  - packages.nginx.nginx_config
  ## NGINX Maintenance Page
  - packages.nginx.nginx_maintenance_page


lb-beavered-logs:
  file.accumulated:
    - filename: /etc/beaver.conf
    - name: beaverd-logs-accumulated
    - text: |-
        [/var/log/nginx/*-access*.json]
        sincedb_write_interval: 3
        format: rawjson
        type: nginx-access

        [/var/log/nginx/error.log]
        sincedb_write_interval: 3
        type: nginx-error
    - require_in:
      - file: beaver_config


lb-newrelic-plugin-agent-monitor_conf:
  file.accumulated:
    - filename: /etc/newrelic/newrelic_plugin_agent.cfg
    - name: newrelic-plugin-agent-monitor
    - text: |-
        nginx:
            name: {{ grains['host'] }}
            host: localhost
            port: 80
            path: /nginx_stub_status
    - require_in:
      - file: newrelic-plugin-agent-monitor_config


nginx_app_vhost:
  file.managed:
    - name: /etc/nginx/sites-enabled/default
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/nginx_app_vhost.conf.jinja
    - template: jinja
    - makedirs: True
    - user: root
    - group: root
    - mode: '0644'
    - require_in:
      - service: nginx_install


{% for ssl_files in ['ssl.crt', 'ssl.key'] %}
/etc/nginx/ssl/{{ssl_files}}:
  file.managed:
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/{{ ssl_files }}
    - template: jinja
    - user: root
    - group: root
    - mode: '0400'
    - require_in:
      - pkg: nginx_install
{% endfor %}


{% for error_pages in [ '503.html' ] %}
/etc/nginx/error_pages/{{ error_pages }}:
  file.managed:
    - source: salt://project/{{ pillar['project_name'] }}/{{ grains.node_type }}/files/{{ error_pages }}
    - mode: '0644'
    - require_in:
      - pkg: nginx_install
{% endfor %}