postgresql-client-92_install:
  pkgrepo.managed:
    - name: deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
  pkg.installed:
    - name: postgresql-client-9.2
    - require:
      - pkgrepo: postgresql-client-92_install