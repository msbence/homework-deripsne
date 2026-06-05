<!-- DOCSIBLE START -->

# 📃 Role overview

## mongodb



Description: Role to configure a mongodb container

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/06/05 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yaml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [mongodb_admin_username](defaults/main.yaml#L1)   | str | `admin` |    
| [mongodb_admin_password](defaults/main.yaml#L2)   | str | `passw0rd` |    





### Tasks


#### File: tasks/exporter.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install podman | ansible.builtin.apt | False |
| Create mongodb_exporter container | containers.podman.podman_container | False |

#### File: tasks/main.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Deploy MongoDB | ansible.builtin.import_tasks | False |
| Deploy MongoDB Exporter | ansible.builtin.import_tasks | False |

#### File: tasks/mongodb.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install podman | ansible.builtin.apt | False |
| Create mongodb data directory | ansible.builtin.file | False |
| Create mongodb container | containers.podman.podman_container | False |
| Fetch mongodb GPG key | ansible.builtin.get_url | False |
| Dearmor and install mongodb GPG key | ansible.builtin.command | False |
| Add mongodb repository | ansible.builtin.apt_repository | False |
| Install mongosh package | ansible.builtin.apt | False |







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
