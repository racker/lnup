auto_updates:
  pkg.installed:
    - name: unattended-upgrades
  file.managed:
    - name: /etc/apt/apt.conf.d/20auto-upgrades
    - contents: |-
        APT::Periodic::Update-Package-Lists "1";
        APT::Periodic::Unattended-Upgrade "1";
    - user: root
    - group: root