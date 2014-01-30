base:
    '*':
        - global_settings

    'env:{{ grains.env }}':
        - match: grain
        - {{ grains.env }}_settings