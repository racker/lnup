kibana_install:
  git.latest:
    - name: https://github.com/elasticsearch/kibana.git
    - rev: v3.0.0milestone4
    - target: /opt/kibana
    - force: true
    - require:
      - pkg: git_install