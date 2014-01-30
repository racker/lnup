python-psycopg2_install:
  pip.installed:
    - name: psycopg2
    - require:
      - pkg: python-pip_install ## So it can install via PIP
      - pkg: python-dev_install
      - pkg: libpq-dev_install