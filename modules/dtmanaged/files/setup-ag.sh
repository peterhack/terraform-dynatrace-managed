#!/usr/bin/env bash

# This script template is expected to be populated during the setup of an
# ActiveGate node. It runs on host startup.

# Log everything we do.
set -x
exec > /var/log/user-data.log 2>&1

mkdir -p /etc/aws/
cat > /etc/aws/aws.conf <<- EOF
[Global]
Zone = ${availability_zone}
EOF

# Create initial logs config.
cat > ./awslogs.conf <<- EOF
[general]
state_file = /var/awslogs/state/agent-state

[/var/log/messages]
log_stream_name = activegate-node-{instance_id}
log_group_name = /var/log/messages
file = /var/log/messages
datetime_format = %b %d %H:%M:%S
buffer_duration = 5000
initial_position = start_of_file

[/var/log/user-data.log]
log_stream_name = activegate-node-{instance_id}
log_group_name = /var/log/user-data.log
file = /var/log/user-data.log
EOF

# Download and run the AWS logs agent.
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
python ./awslogs-agent-setup.py --non-interactive --region us-east-1 -c ./awslogs.conf

# Start the awslogs service, also start on reboot.
# Note: Errors go to /var/log/awslogs.log
service awslogs start
chkconfig awslogs on

# ActiveGate setup
# See: https://www.dynatrace.com/support/help/setup-and-configuration/dynatrace-managed/installation/how-to-install-a-cluster-activegate/

# Install packages required to setup ActiveGate 
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion
yum update -y

# Note: The step below is not in the official docs, I needed it to install
# Docker. If anyone finds out why, I'd love to know.
# See: https://forums.aws.amazon.com/thread.jspa?messageID=574126
yum-config-manager --enable rhui-REGION-rhel-server-extras

# Allow the ec2-user to sudo without a tty, which is required when we run post
# install scripts on the server.
echo Defaults:ec2-user \!requiretty >> /etc/sudoers
