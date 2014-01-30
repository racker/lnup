## Git URL
git_url:

## Timezone
timezone: America/Chicago

## Project name
project_name: app

## Application's home
document_root: /opt/apps

## NGINX timeout in seconds, and uWSGI will be (time_out - 1)
time_out: 120

## LDAP Stuff
ldap_uri: ldaps://
ldap_base: OU= O=

## New Relic
new_relic:
  license_key:
  ssl: true

## Beaver
beaver:
  version: 30

## Logstash Stuff
logstash:
  version: 1.2.1
  url: https://logstash.objects.dreamhost.com/release/logstash-1.2.1-flatjar.jar
  sha512_hash: 5cc59a7ebcc8c8f05350d2f0524f3d9824a210a8fd59b2578fced8f104150d010a2db0eef00ba5b36bb74ab71064af4f430ba56582f95b044e95aa2d0b247326

## Database Stuff
database_user:
database_name:
database_port: 5432
database_engine: django.db.backends.postgresql_psycopg2

## Mailgun
mailgun_access_key:
mailgun_server_name:

## Django Secret key... shhhhhhhh
secret_key:

## SSH Private and Public keys.
ssh:
  private:
    barman: |
      -----BEGIN RSA PRIVATE KEY-----
      -----END RSA PRIVATE KEY-----
    postgres: |
      -----BEGIN RSA PRIVATE KEY-----
      -----END RSA PRIVATE KEY-----
  public:
    master: ''
    barman: ''
    postgres: ''

## SSl CRT and RSA keys
ssl:
  crt: |
    -----BEGIN CERTIFICATE-----
    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----
    -----END CERTIFICATE-----
  rsa: |
    -----BEGIN PRIVATE KEY-----
    -----END PRIVATE KEY-----