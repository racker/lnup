include:
  ## Postgres Stuff
  - packages.libpq-dev
  ## Monitoring
  - packages.newrelic_plugin_agent
  ## uWSGI
  - packages.libcap-dev
  - packages.uwsgi
  - packages.uwsgitop
  ## Python stuff
  - packages.python.python-pip
  - packages.python.python-dev
  - packages.python.python-virtualenv
  - packages.python.python-ldap
  ## Libs
  - packages.libldap2-dev
  - packages.libsasl2-dev
  - packages.libssl-dev
  ## Beaver
  - packages.beaver
 ## Server Stuff
  - project.{{ pillar['project_name'] }}.{{ grains.node_type }}