## Everything gets *.
base:
    '*':
        - packages.vim
        - packages.updates
        - packages.set_time
        - packages.git
        - packages.python.python-software-properties
        - packages.new_relic
        - packages.ssh_keys

## Matches by the nodes grain "node_type", and then goes into the node-types folder for more SLS goodness.
    'node_type:{{ grains.node_type }}':
        - match: grain
        - node-types.{{ grains.node_type }}