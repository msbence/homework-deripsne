# Homework (Bence Madarasz)

> [!TIP]
> TL;DR: The detailed documentation is [here](/deliverables/documentation/README.md).

My task was to deploy a small, production-like Grafana environment on AWS, with a focus on availability and redundancy.  
I had to follow specific requirements, which resulted in some strange solutions. As I was provided with an AWS account paid by the company, I tried to be ultra cost-aware (no LB, no multi-AZ, ...). This took a great toll on the HA-setup, but I will be mentioning all the trade-offs I made due to this contraint.

## Features in a nutshell

- EC2 instance with on/off schedule and extra ZFS storage (mirrored)
- Grafana 13, exposed over HTTPS, backed up
- MongoDB 8
- Full IaC with Terraform and Ansible (except the Grafana dashboards)
- Tries to keep security a priority (again: cost was a factor)
- Formatting, linting, auto-documenting
- Pre-commit hooks to guard the repo cleanliness

![pre-commit](/.assets/pre-commit.png)

## Structure

This repository consists of 3 main steps, each of them represented by a folder:

### 1: Provisioning

The [provisioning](/provisioning/) folder contains Terraform code, responsible for providing all the resources that the configuration step depends on. It includes spinning up the EC2 instance, creating and configuring the S3 buckets, etc...

If something is achievable with an AWS service, it also provisions that. An example would be the EventBridge schedule that turns off and on the EC2 instance.

### 2: Configuration

In the [configuration](/configuration/) directory you can find the Ansible playbook (with several roles) that for example sets up the EC2 instance and deploys the Grafana and MongoDB containers.

### 3: Deliverables

My task description had a "deliverables" section, so I've decided to move those to a dedicated place.

It mainly contains the [detailed documentation](/deliverables/documentation/README.md) on what I did.

## Notes

### LLM usage

LLMs are helpful tools, and I sometimes use them to increase efficiency (or just to tinker with them: I have an old NVIDIA Tesla in my homelab), but I also like to understand what I do and why I do it... I also believe that just from generated "AI" code you would not see my coding style, the way I think, etc... Therefore:

**This repository DOES NOT contain any LLM-generated code, scripts, or files. LLMs were, however, used for: grammar checks and troubleshooting.**

On a related note: some ideas and code were borrowed from my homelab IaC repo, but those were also handwritten.

### Git history

The way GitHub visualizes my commit history is NOT accurate. When moving from my dekstop to my notebook I forgot to set up GPG commit signing and therefore had to amend and sign them retrospectievly. It looks correct on GitLab and `git` itself, but not on GitHub. If you are interested in the exact development timeline then clone this repo and use `git log`.
