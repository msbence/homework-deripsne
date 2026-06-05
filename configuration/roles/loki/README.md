<!-- DOCSIBLE START -->

# 📃 Role overview

## loki



Description: Role to deploy loki

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/06/05 |














### Tasks


#### File: tasks/loki.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install podman | ansible.builtin.apt | False |
| Create loki data directory | ansible.builtin.file | False |
| Install loki config | ansible.builtin.copy | False |
| Create loki container | containers.podman.podman_container | False |

#### File: tasks/main.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Deploy Loki | ansible.builtin.import_tasks | False |







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
