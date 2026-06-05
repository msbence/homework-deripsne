<!-- DOCSIBLE START -->

# 📃 Role overview

## grafana



Description: Role to configure grafana (and nginx)

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/06/05 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yaml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [grafana_server_url_scheme](defaults/main.yaml#L1)   | str | `http` |    
| [grafana_server_url_fqdn](defaults/main.yaml#L2)   | str | `localhost` |    
| [grafana_server_url_port](defaults/main.yaml#L3)   | int | `3000` |    
| [grafana_admin_username](defaults/main.yaml#L4)   | str | `admin` |    
| [grafana_admin_password](defaults/main.yaml#L5)   | str | `passw0rd` |    
| [grafana_backup_bucket](defaults/main.yaml#L6)   | str | `superior-aws-bucket` |    





### Tasks


#### File: tasks/grafana.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install podman | ansible.builtin.apt | False |
| Create grafana data directory | ansible.builtin.file | False |
| Create grafana container | containers.podman.podman_container | False |
| Give 5 seconds to Grafana to boot | ansible.builtin.wait_for | False |
| Configure datasource for Prometheus | community.grafana.grafana_datasource | False |
| Configure datasource for Loki | community.grafana.grafana_datasource | False |
| Put backup script on host | ansible.builtin.template | False |
| Deploy grafana backup cronjob | ansible.builtin.cron | False |

#### File: tasks/main.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Deploy Grafana | ansible.builtin.import_tasks | False |
| Configure nginx | ansible.builtin.import_tasks | False |

#### File: tasks/nginx.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install nginx and certbot | ansible.builtin.apt | False |
| Check if SSL certificate exists | ansible.builtin.stat | False |
| Request SSL cert if missing | ansible.builtin.command | True |
| Install nginx config for grafana | ansible.builtin.template | False |
| Enable the nginx site | ansible.builtin.file | False |







## Author Information
Bence Madarasz

#### License

MIT

#### Minimum Ansible Version

14

#### Platforms

No platforms specified.

#### Dependencies

No dependencies specified.
<!-- DOCSIBLE END -->
