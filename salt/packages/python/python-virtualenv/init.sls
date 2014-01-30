python-virtualenv_install:
  pip.installed:
    - name: virtualenv
    - require:
      - pkg: python-pip_install ## So it can install via PIP