{% set anaconda = salt['pillar.get']('anaconda') %}

app_user:
  user.present:
      - name: {{anaconda.user}}
      - home: {{anaconda.user_home}}
  file.append:
    - name: {{anaconda.user_home}}/.bash_profile
    - text: export PATH={{anaconda.anaconda_home}}/bin:$PATH


download_anaconda:
  file.managed:
    - name:  {{anaconda.download_at}}
    - mode: 755
    - user: {{anaconda.user}}
    - source: {{anaconda.url}}
    - source_hash: {{anaconda.source_hash}}
    - unless: test -f {{anaconda.download_at}}
    - require:
      - user: app_user


run_installer:
  cmd.run:
    - name: {{anaconda.download_at}} -b -p  {{anaconda.anaconda_home}} 
    - runas: tapdaq_apps
    - require:
      - file: download_anaconda
    - unless: test -d {{anaconda.anaconda_home}}



