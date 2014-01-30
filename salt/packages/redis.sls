redis_install:
  pkgrepo.managed:
    - ppa: chris-lea/redis-server
  pkg.installed:
    - name: redis-server
  sysctl.present:
    - name: vm.overcommit_memory
    - value: 1
  service.running:
    - name: redis-server
    - enable: True
    - watch: 
      - file: /etc/redis/redis.conf
    - require:
      - file: redis_databases
      - file: redis_memory


redis_databases:
  file.replace:
    - name: /etc/redis/redis.conf
    - pattern: "databases 16"
    - repl: "databases 3"
    - require:
      - pkg: redis_install


redis_memory:
  file.replace:
    - name: /etc/redis/redis.conf
    - pattern: "# maxmemory <bytes>"
    - repl: "maxmemory {{grains.mem_total  * 1024 * 1024 / 4 * 3}}"
    - require:
      - pkg: redis_install