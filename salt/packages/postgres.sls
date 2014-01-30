postgres_install:
  pkgrepo.managed:
    - name: deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
    - key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
  pkg.installed:
    - pkgs:
      - postgresql-9.2
      - postgresql-server-dev-9.2
  service.running:
    - name: postgresql
    - enable: True