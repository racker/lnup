logstash_install:
  user.present:
    - name: logstash
    - shell: /bin/false
    - home: /opt/logstash
    - createhome: True
    - gid_from_name: True
  file.managed:
    - name: /opt/logstash/logstash-{{ pillar['logstash']['version'] }}-flatjar.jar
    - source: {{ pillar['logstash']['url'] }}
    - source_hash: sha512={{ pillar['logstash']['sha512_hash'] }}
    - user: logstash
    - group: adm
    - file_mode: '0640'


logstash_upstart:
  file.managed:
    - name: /etc/init/logstash.conf
    - source: salt://packages/logstash/files/logstash.upstart.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: '0640'
    - require:
      - file: logstash_install