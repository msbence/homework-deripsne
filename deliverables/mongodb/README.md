# MongoDB

The whole process is automated via Ansible ([mongodb role](/configuration/roles/mongodb)).

## Requirements

- Ubuntu 24.04 LTS host
- Access to Docker Hub (on the host)

## Steps

_As in: what the role does._

- Installing podman (containers are easier to manage and more portable (Kubernetes, Fargate, etc...))
- Setting up a directory for persistent storage where the data will be mounted
- Launching the official MongoDB container, with several options configured:
  - Make sure the container is always (re)started
    - `restart_policy: always`
  - Default port (27017) exposed so that other hosts in the network can reach it
    - `ports: "27017:27017"`
  - Mounting the data directory (a volume would be also an option, but this can support multiple ways of doing backups)
    - `user: ":"` (required to make sure the data can be written by the container user)
    - `volume: /mongodb:/data/db:Z`
  - Sets the admin credentials via environment variables (which are read from the SSM Parameter Store (SecureString))
    - `MONGO_INITDB_ROOT_USERNAME: "{{ mongodb_admin_username }}"`
    - `MONGO_INITDB_ROOT_PASSWORD: "{{ mongodb_admin_password }}"`
- While not required on the server, it also installs the `mongosh` client so that we can verify that the instance is reachable
  - `mongosh "mongodb://<username>:<password>@localhost"`

## Example

![MongoDB Test](/.assets/mongo-test.png)
