#!/bin/bash
#
# script for getting metadata inside a cloud container about the
# cloud provider and the runtime environment

json_start() {
	printf "{"
}
json_end() {
	printf "}"
}
json_value() {
	local k=$1
	local v=$2
	local m=${3:-true}
	printf "\"${k}\":\"${v}\""
	if [ $m = true ];
	then
		printf ","
	fi
}

#
# EC2 implementation
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html
#
check_aws() {
	public_ipv4=`curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null`
	if [ "$public_ipv4" != "" ] && [[ ! "$public_ipv4" =~ "<!DOCTYPE" ]];
	then
		hostname=`curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/public-hostname`
		zone=`curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/placement/availability-zone`
		id=`curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/instance-id`
		instancetype=`curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/instance-type`
		private_ipv4=`curl -s --connect-timeout 1 http://169.254.169.254/latest/meta-data/local-ipv4`
		json_start
		json_value "provider" "amazonec2"
		json_value "hostname" $hostname
		json_value "public_ipaddress" $public_ipv4
		json_value "private_ipaddress" $private_ipv4
		json_value "zone" $zone
		json_value "id" $id
		json_value "type" $instancetype false
		json_end
		exit 0
	fi
}

#
# Google Compute Engine implementation
# https://cloud.google.com/compute/docs/storing-retrieving-metadata
#
check_gce() {
	hostname=`curl -H "Metadata-Flavor: Google" -s --connect-timeout 1 http://metadata.google.internal/computeMetadata/v1/instance/hostname 2>/dev/null`
	if [ "$hostname" != "" ];
	then
		id=`curl -H "Metadata-Flavor: Google" -s --connect-timeout 1 http://metadata.google.internal/computeMetadata/v1/instance/id`
		zone=`curl -H "Metadata-Flavor: Google" -s --connect-timeout 1 http://metadata.google.internal/computeMetadata/v1/instance/zone | cut -d'/' -f4`
		machinetype=`curl -H "Metadata-Flavor: Google" -s --connect-timeout 1 http://metadata.google.internal/computeMetadata/v1/instance/machine-type | cut -d'/' -f4`
		public_ipv4=`curl -H "Metadata-Flavor: Google" -s --connect-timeout 1 http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip`
		private_ipv4=`curl -H "Metadata-Flavor: Google" -s --connect-timeout 1 http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip`
		json_start
		json_value "provider" "gce"
		json_value "hostname" $hostname
		json_value "public_ipaddress" $public_ipv4
		json_value "public_ipaddress" $private_ipv4
		json_value "zone" $zone
		json_value "id" $id
		json_value "type" $machinetype false
		json_end
		exit 0
	fi
}

check_aws
check_gce

# if we get here, no provider found
exit 1
