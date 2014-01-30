app_user:
  file.directory:
    - name: {{ pillar['document_root'] }}
  user.present:
    - name: {{ pillar['project_name'] }}
    - shell: /bin/bash
    - home: {{ pillar['document_root'] }}/{{ pillar['project_name'] }}
    - createhome: True
    - gid_from_name: True
    - require:
        - file: app_user