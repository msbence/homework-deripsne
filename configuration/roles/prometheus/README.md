<!-- DOCSIBLE START -->

# 📃 Role overview

## prometheus



Description: Role to deploy prometheus

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/06/05 |














### Tasks


#### File: tasks/main.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Deploy Prometheus | ansible.builtin.import_tasks | False |

#### File: tasks/prometheus.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install podman | ansible.builtin.apt | False |
| Create prometheus data directory | ansible.builtin.file | False |
| Install prometheus config | ansible.builtin.copy | False |
| Create prometheus container | containers.podman.podman_container | False |







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
