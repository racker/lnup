include:
  ## NGINX
  - packages.nginx
  ## Monitoring
  - packages.newrelic_plugin_agent
  ## Barman the Postgres Backup
  - packages.barman
  - packages.postgresql-client-common
  - packages.postgresql-client-92
  ## Python Stuff
  - packages.python.python-pip
  ## Logstash
  - packages.openjdk-7-jre-headless
  - packages.logstash
  ## Kibana
  - packages.kibana
  ## Beaver
  - packages.beaver
  ## Server Stuff
  - project.{{ pillar['project_name'] }}.{{ grains.node_type }}