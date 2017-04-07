Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/text/x-shellscript; charset="us-ascii"
#!/bin/bash

echo ECS_CLUSTER=${cluster_name} >> /etc/ecs/ecs.config
echo ECS_RESERVED_MEMORY=128 >> /etc/ecs/ecs.config
echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=10m >> /etc/ecs/ecs.config
echo ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"syslog\",\"awslogs\"] >> /etc/ecs/ecs.config

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/text/x-shellscript; charset="us-ascii"
#!/bin/bash

yum install -y aws-cli bc jq

cat > /usr/local/bin/metricscript.sh <<- 'EOF'
#!/bin/bash

### Get docker free data and metadata space and push to CloudWatch metrics
###
### requirements:
###  * must be run from inside an EC2 instance
###  * docker with devicemapper backing storage
###  * aws-cli configured with instance-profile/user with the put-metric-data permissions
###  * local user with rights to run docker cli commands
###
### Created by Jay McConnell

# Collect region and instanceid from metadata
AWSREGION=`curl -ss http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
AWSINSTANCEID=`curl -ss http://169.254.169.254/latest/meta-data/instance-id`

function convertUnits {
  # convert units back to bytes as both docker api and cli only provide friendly units
  if [ "$1" == "b" ] ; then
    echo $2
  elif [ "$1" == "kb" ] ; then
    echo "$2*1000" | bc | awk '{print $1}' FS="."
  elif [ "$1" == "mb" ] ; then
    echo "$2*1000*1000" | bc | awk '{print $1}' FS="."
  elif [ "$1" == "gb" ] ; then
    echo "$2*1000*1000*1000" | bc | awk '{print $1}' FS="."
  elif [ "$1" == "tb" ] ; then
    echo "$2*1000*1000*1000*1000" | bc | awk '{print $1}' FS="."
  else
    echo "Unknown unit $1"
    exit 1
  fi
}

function getMetric {
  # Get freespace and split unit
  if [ "$1" == "Data" ] || [ "$1" == "Metadata" ] ; then
    echo $(docker info | grep "$1 Space Available" | awk '{print tolower($5), $4}')
  else
    echo "Metric must be either 'Data' or 'Metadata'"
    exit 1
  fi
}

data=$(convertUnits `getMetric Data`)
aws cloudwatch put-metric-data --value $data --namespace ECS/$AWSINSTANCEID --unit Bytes --metric-name FreeDataStorage --region $AWSREGION
data=$(convertUnits `getMetric Metadata`)
aws cloudwatch put-metric-data --value $data --namespace ECS/$AWSINSTANCEID --unit Bytes --metric-name FreeMetadataStorage --region $AWSREGION
data=$(df -B1 --output=avail /dev/xvda1 | sed 1d)
aws cloudwatch put-metric-data --value $data --namespace ECS/$AWSINSTANCEID --unit Bytes --metric-name FreeRootStorage --region $AWSREGION

EOF

chmod +x /usr/local/bin/metricscript.sh
echo '*/5 * * * * root /usr/local/bin/metricscript.sh' > /etc/cron.d/ecsmetrics

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/text/x-shellscript; charset="us-ascii"
#!/bin/bash

# Install awslogs and the jq JSON parser
yum install -y awslogs

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = /var/log/dmesg
log_stream_name = {cluster}/{container_instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = /var/log/messages
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = /var/log/docker
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log.*
log_group_name = /var/log/ecs/ecs-init.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = /var/log/ecs/ecs-agent.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

EOF

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/text/upstart-job; charset="us-ascii"

#upstart-job
description "Configure and start CloudWatch Logs agent on Amazon ECS container instance"
author "Amazon Web Services"
start on started ecs

script
	exec 2>>/var/log/ecs/cloudwatch-logs-start.log
	set -x

	until curl -s http://localhost:51678/v1/metadata
	do
		sleep 1
	done

	# Grab the cluster and container instance ARN from instance metadata
	cluster=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .Cluster')
	container_instance_id=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $2}' )

	# Replace the cluster name and container instance ID placeholders with the actual values
	sed -i -e "s/{cluster}/$cluster/g" /etc/awslogs/awslogs.conf
	sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf

	service awslogs start
	chkconfig awslogs on
end script
--==BOUNDARY==--
