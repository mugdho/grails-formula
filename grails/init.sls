{% from "grails/map.jinja" import grails with context %}

# Set grails version
{% set version = grails.version -%}
{% set base_download_url = grails.base_download_url -%}
{% set install_dir = grails.install_base + '/grails-' + version -%}
{% set current_dir = grails.install_base + '/current' -%}

check-if-zip-exists:
    pkg.installed:
    - pkgs:
        - zip

download-grails-zip:
  cmd.run:
    - name: wget {{ base_download_url }}/v{{ version }}/grails-{{ version }}.zip
    - cwd: {{ grails.tmp_dir }}
    - unless: test -d {{ grails.install_base }}

grails-unarchive:
    archive.extracted:
        - name: {{ grails.install_base }}
        - source: {{ grails.tmp_dir }}/grails-{{ version }}.zip
        - archive_format: zip

grails-make-current:
    file:
        - symlink
        - name: {{ grails.install_base }}/current
        - makedirs: True
        - target: {{ install_dir }}

{% for item in grails.link_to_bin %}
grails-add-to-bin-{{ item.name }}:
    file:
        - symlink
        - name: /usr/bin/{{ item.name }}
        - target: {{ current_dir }}/{{ item.path }}
{% endfor %}
