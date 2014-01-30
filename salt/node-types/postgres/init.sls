include:
  ## Python stuff
  - packages.python.python-pip
  - packages.python.python-dev
  ## Postgres Stuff
  - packages.libpq-dev
  - packages.python.python-psycopg2
  - packages.postgres
  ## Monitoring
  - packages.newrelic_plugin_agent
  ## Beaver
  - packages.beaver
  ## Node Stuff
  - project.{{ pillar['project_name'] }}.{{ grains.node_type }}