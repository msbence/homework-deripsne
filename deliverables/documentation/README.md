# Documentation

I made several trade-offs during the implementation: most of them was to save costs, few of them were about complexity.

In the sections below I tried to summarize what I did, how the architecture looks like, and describe how and why the solution works - albeit not being production-grade.

## Architecture overview

![architecture](/.assets/architecture.png)

## Networking

The EC2 instance is located in the public subnets, using the default VPC.  
On the default VPC the only modification that I did was to attach an S3 Gateway Endpoint, because that is free and should the setup use a NAT Gateway in the future it can save a great deal of cost by not letting S3 data flow through it.

**This is absolutely NOT a production-grade setup.**
I wanted to save costs by not deploying a NAT Gateway, or a Load Balancer. I made these design choices on purpose, but it has a great impact on security, availability, and redundancy.

## Grafana

The latest (at the time of writing) Grafana OSS (formerly CE) is deployed on the EC2 host. I choose to leverage Podman, as having a containerized approach from the beginning introduces means to make it portable (like move it to EKS, Fargate, ...), it's also better for security as it provides some level of isolation (not on the kernel-level though), and last but not least: it means less Ansible tasks.

While some parts of the deployment are in code, I've decided to create dashboards by hand. The instance itself is being backed up, so there are some means to restore those as well.

A user may use this to track the status of the EC2 instance itself, view logs, and check MongoDB health (this is done via Prometheus and Loki).

## ZFS

I provisioned two additional EBS volumes for the EC2 instance, which shows up as NVMe drives on the host. Configuring the mirror itself is done by Ansible, with some additional tweaks from my side:

- ARC is limited to 512M as we are low on RAM
- `ashift` is set to 12 which is a balanced value for SSDs
- deduplication is NOT enabled, to save memory
- compression is enabled, to still have some space-saving measures in place

I choose not to encrypt the pool, since the underlying EBS volumes have encryption enabled already.

## Backup

Backups are implemented via a cronjob set on the EC2 host (installed via Ansible). They run daily at 19:00 UTC -> normally I would use a later timeslot but the instance shuts down at 20:00 UTC.

Backups are made by compressing the `grafana.db` and the `plugins` directory into an archive (filename contains the date), and that being sent to an S3 bucket.

Just copying the SQlite database of a running instance is a bold move. On production I would configre Grafana to use Postgres and use a dedicated tool to take backups. Or just go RDS.

The backup bucket has versioning, object lock, retention (transition and expiration), and also ownership controls configured. The latter is not necessary right now, but I've assumed that later it would be moved to a dedicated AWS account. The instance-attached IAM role only allows Put and Get operations.

### Restore

All you have to do is redeploy the instance from code, then stop the `grafana` container, fetch the latest backup `.tar` file, extract it, and override the existing files/folders:

1. `podman stop grafana`
2. `cd /tmp`
3. `s3cmd get s3://backup-bucket/[...].tar .`
4. `tar xvzf [...].tar`
5. `rm -rf /monitoring/grafana/plugins /monitoring/grafana/grafana.db`
6. `cp grafana.db /monitoring/grafana/grafana.db`
7. `cp -r plugins monitoring/grafana/plugins`
8. `podman start grafana`

## Night shutdown

The EC2 instance is being shut down at 20:00 UTC, and started up at 06:00 UTC. This is to save costs.  
My implementation was done with EventBridge schedules, and it does the job. However, on a bigger scale, going with the [AWS Instance Scheduler](https://docs.aws.amazon.com/solutions/latest/instance-scheduler-on-aws/solution-overview.html) CloudFormation stack would make more sense.

Note: This scheduling is the reason why I had to use an Elastic IP. Normally instances are getting a different public IP when being stopped-started, but I needed to have DNS name resolution using a non-amazonaws domain, therefore the best approach that I found was to use the Elastic IP (and pay a tiny amount of money when the instance is stopped).

## Security controls

### Network

The EC2 instance has several Security Groups attached to it, to make the networking more secure even in this cost-optimized environment:

- Ingress: only allow 80 and 443 TCP
- Egress: allow ALL (this could be fine-tuned though, as long as the EC2 Metadata Server, SSM, S3, some internal apt and container registry remains reachable)

### EC2 Instance

Connections to the instance is not possible over SSH. Admins must use SSM. This solution is quite powerful as it provides audit logs (CloudTrail), and also considers IAM roles.

### Backup bucket

Deleting from the bucket is not possible. Overwriting the files are also not possible due to versioning.
The bucket also implements object locking, which is a standard when it comes to backup. I choose GOVERNANCE mode on purpose, so that the bucket can be cleaned up by the root account; on prod I would go COMPLIANCE.

### Repository

The repo contains no secrets at all. It reads everything from the Parameter Store, where the secrets are stored as SecureStrings.

## Limitations & next steps

1. While SCIM is a Grafana Enterprise feature, simple SSO is possible. I would connect it to a central user directory, which also implements MFA.
2. The current networking setup is super simple. I would use a non-default VPC, with private subnets, and an AWS Load Balancer (with an ACM certificate) instead of NGINX.
3. A simpler WAF put in front of Grafana would also increase security.
4. The current backup of Grafana is suboptimal (just like the DB setup itself): move to postgres and use a native solution (worst case a `pgdump`).
5. While this needs support from the consumer as well, going with Secrets Manager instead of the Parameter Store would provide more flexibility (cross-account support, rotation).
6. While SSM is good for security, it also results in a horrible Ansible performance... I would either setup a dedicated and hardened bastion jumphost, or even better: deploy CI runners within the network and implement CI/CD for Ansible.
7. Most importantly: to cover availability and redundancy, I would move the whole Grafana container to Fargate (or ECS-EC2), and get rid of this single-AZ instance.
