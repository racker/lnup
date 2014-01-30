set_time:
  pkg.installed:
    - name: ntp
  service.running:
    - name: ntp
    - enable: True
    - require:
      - pkg: set_time
  timezone.system:
    - name: {{ pillar['timezone'] }}
    - utc: True