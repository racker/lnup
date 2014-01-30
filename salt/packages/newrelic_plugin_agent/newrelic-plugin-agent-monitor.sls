newrelic-plugin-agent-monitor_config:
  file.managed:
    - name: /etc/newrelic/newrelic_plugin_agent.cfg
    - source: salt://packages/newrelic_plugin_agent/files/newrelic-plugin-agent-monitor.cfg.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0400'
    - require:
      - pip: newrelic-plugin-agent-monitor_install