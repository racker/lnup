uwsgitop_install:
  pip.installed:
    - name: uwsgitop
    - require:
      - pkg: python-pip_install ## So it can install via PIP