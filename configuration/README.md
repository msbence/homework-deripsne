# Configuration

In this directory you can find the Ansible playbook (with several roles) that for example sets up the EC2 instance and deploys the Grafana and MongoDB containers.

It looks up SSM Parameters and also leverages the AWS EC2 dynamic inventory plugin, therefore an AWS login is required.

## Usage

1. `python3 -m venv venv`
2. `source venv/bin/activate`
3. `pip install -r requirements.txt`
4. `ansible-galaxy install -r requirements.yaml`
5. `aws login`
6. `ansible-playbook main.yaml`

![ansible](/.assets/ansible.png)
