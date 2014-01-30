newrelic-plugin-agent-monitor_install:
  pip.installed:
    - name: newrelic-plugin-agent
    - require:
      - pkg: python-pip_install ## So it can install via PIP 
      - service: new-relic_install
  file.managed:
    - name: /etc/init.d/newrelic_plugin_agent
    - source: salt://packages/newrelic_plugin_agent/files/newrelic_plugin_agent.startup
    - template: jinja
    - user: root
    - group: root
    - mode: '0750'
  service.running:
    - name: newrelic_plugin_agent
    - enable: True
    - require:
      - file: newrelic-plugin-agent-monitor_config