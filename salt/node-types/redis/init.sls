include:
  ## Redis
  - packages.redis
  ## Python stuff
  - packages.python.python-pip
  ## Monitoring
  - packages.newrelic_plugin_agent
 ## Server Stuff
  - project.{{ pillar['project_name'] }}.{{ grains.node_type }}