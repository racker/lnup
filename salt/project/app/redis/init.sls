include:
  ## Newrelic Plugin Agent Monitoring
  - packages.newrelic_plugin_agent.newrelic-plugin-agent-monitor


redis-newrelic-plugin-agent-monitor_conf:
  file.accumulated:
    - filename: /etc/newrelic/newrelic_plugin_agent.cfg
    - name: newrelic-plugin-agent-monitor
    - text: |-
        redis:
            name: {{ grains['host'] }}
    - require_in:
      - file: newrelic-plugin-agent-monitor_config