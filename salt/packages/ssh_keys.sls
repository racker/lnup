app_ssh_pub:
  ssh_auth.present:
    - user: root
    - enc: ssh-rsa
    - names:
      - {{ pillar['ssh']['public']['master'] }}