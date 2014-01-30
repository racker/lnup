new-relic_install:
  pkgrepo.managed:
    - name: deb http://apt.newrelic.com/debian/ newrelic non-free
    - key_url: http://download.newrelic.com/548C16BF.gpg
  pkg.installed:
    - name: newrelic-sysmond
    - require:
      - pkgrepo: new-relic_install
  file.replace:
    - name: /etc/newrelic/nrsysmond.cfg
    - pattern: "license_key=REPLACE_WITH_REAL_KEY"
    - repl: "license_key={{ pillar['new_relic']['license_key'] }}"
    - require:
      - pkg: new-relic_install
  service.running:
    - name: newrelic-sysmond
    - enable: True
    - reload: True
    - require:
      - file: new-relic_install


new-relic_ssl:
  file.replace:
    - name: /etc/newrelic/nrsysmond.cfg
    - pattern: "#ssl=false"
    - repl: "ssl={{ pillar['new_relic']['ssl'] }}"
    - require:
      - pkg: new-relic_install