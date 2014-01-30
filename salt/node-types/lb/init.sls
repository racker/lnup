include:
  ## NGINX
  - packages.nginx
  ## Monitoring
  - packages.newrelic_plugin_agent
  ## Pytbon stuff
  - packages.python.python-pip
  - packages.python.python-dev
  ## Beaver
  - packages.beaver
 ## Server Stuff
  - project.{{ pillar['project_name'] }}.{{ grains.node_type }}