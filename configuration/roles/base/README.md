<!-- DOCSIBLE START -->

# 📃 Role overview

## base



Description: Role to configure basic components on a host

| Field                | Value           |
|--------------------- |-----------------|
| Readme update        | 2026/06/05 |








### Defaults

**These are static variables with lower priority**

#### File: defaults/main.yaml

| Var          | Type         | Value       |
|--------------|--------------|-------------|
| [base_zfs_arc_max_bytes](defaults/main.yaml#L2)   | str | `{{ (0.5 * 1024 * 1024 * 1024) ¦ int }}` |    





### Tasks


#### File: tasks/alloy.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Create alloy user | ansible.builtin.user | False |
| Add alloy user to systemd-journal group | ansible.builtin.user | False |
| Create alloy directory | ansible.builtin.file | False |
| Check if version file exists | ansible.builtin.stat | False |
| Create initial version file | ansible.builtin.file | True |
| Read local alloy version | ansible.builtin.slurp | False |
| Get latest release | block | False |
| Fetch latest release | ansible.builtin.uri | False |
| Set alloy version to {{ base_alloy_latest_release.json.tag_name[1:] }} | ansible.builtin.set_fact | False |
| Download latest alloy binary | ansible.builtin.unarchive | True |
| Register version in file | ansible.builtin.copy | True |
| Install alloy service | ansible.builtin.copy | False |
| Install alloy configuration | ansible.builtin.template | False |

#### File: tasks/main.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install base packages | ansible.builtin.import_tasks | False |
| Configure ZFS | ansible.builtin.import_tasks | False |
| Install node exporter | ansible.builtin.import_tasks | False |
| Install alloy | ansible.builtin.import_tasks | False |

#### File: tasks/node_exporter.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Create node_exporter user | ansible.builtin.user | False |
| Create node_exporter directory | ansible.builtin.file | False |
| Check if version file exists | ansible.builtin.stat | False |
| Create initial version file | ansible.builtin.file | True |
| Read local node_exporter version | ansible.builtin.slurp | False |
| Get latest release | block | False |
| Fetch latest release | ansible.builtin.uri | False |
| Set node_exporter version to {{ base_node_exporter_latest_release.json.tag_name[1:] }} | ansible.builtin.set_fact | False |
| Download latest node_exporter binary | ansible.builtin.unarchive | True |
| Register version in file | ansible.builtin.copy | True |
| Install node_exporter service | ansible.builtin.copy | False |

#### File: tasks/packages.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Run apt update first | ansible.builtin.apt | False |
| Install common packages | ansible.builtin.apt | False |
| Run apt autoclean to cleanup | ansible.builtin.apt | False |
| Run apt autoremove to cleanup | ansible.builtin.apt | False |

#### File: tasks/zfs.yaml

| Name | Module | Has Conditions |
| ---- | ------ | -------------- |
| Install ZFS packages | ansible.builtin.apt | False |
| Limit ARC due to low RAM | ansible.builtin.lineinfile | False |
| Create mirrored ZFS pool | community.general.zpool | False |







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
