Description
===========

A cookbook to setup a hardware agnostic provisioning node powered by Razor with the Razor Micro Kernel image imported. 
This cookbook falls under stage 1-3 for Data Center Automation. Stage 3 (Service Provisioning) can be configured to execute
post OS install. The Chef Broker hand off to chef to run any respective cookbooks (Hadoop, OpenStack, CloudStack, etc).


Requirements
============

Ubuntu 12.0.4.1 LTS as the install platorm. Others will be supported in the future. All target OS platforms supported by Razor.

	Template Name                Description            

	debian_wheezy           Debian Wheezy Model             
	opensuse_12             OpenSuSE Suse 12 Model          
	redhat_6                RedHat 6 Model                  
	sles_11                 SLES 11 Model                   
	ubuntu_oneiric          Ubuntu Oneiric Model            
	ubuntu_precise          Ubuntu Precise Model            
	ubuntu_precise_ip_pool  Ubuntu Precise Model (IP Pool)  
	vmware_esxi_5           VMware ESXi 5 Deployment        
	centos_6                CentOS 6 Model                  
	oraclelinux_6           Oracle Linux 6 Model   

*For debian, use the mini.iso for netboot

Chef Broker:

Success (node registration):

Ubuntu 12.0.4.1 LTS

Failure (node registration):

Debian Wheezy




Attributes
==========

	#Razor
	default[:metalprov][:razor][:dist] = "master.zip"
	default[:metalprov][:razor][:path] = "https://github.com/puppetlabs/Razor/archive/master.zip"
	default[:metalprov][:ipxe][:dist] = "ipxe"
	default[:metalprov][:ipxe][:path] = "https://s3.amazonaws.com/velankanidownloads/ipxe.iso"
	default[:metalprov][:ipxe][:dist_usb] = "ipxe"
	default[:metalprov][:ipxe][:path_usb] = "https://s3.amazonaws.com/velankanidownloads/ipxe.usb"
	default[:metalprov][:ipxe][:dist_misc] = "undionly"
	default[:metalprov][:ipxe][:path_misc] = "https://s3.amazonaws.com/velankanidownloads/undionly.kpxe"
	default[:metalprov][:razor][:mk] = "rz_mk_prod-image.0.9.3.0"
	default[:metalprov][:razor][:mk_path] = "https://github.com/downloads/puppetlabs/Razor-Microkernel/rz_mk_prod-image.0.9.3.0.iso"



	#DHCP
	default[:metalprov][:dhcpd][:dns_server] = "8.8.8.8"
	default[:metalprov][:dhcpd][:next_server] = "192.168.73.162"
	default[:metalprov][:dhcpd][:subnet] = "192.168.73.0"
	default[:metalprov][:dhcpd][:subnet_mask] = "255.255.255.0"
	default[:metalprov][:dhcpd][:broadcast] = "192.168.73.255"
	default[:metalprov][:dhcpd][:gateway] = "192.168.73.2"
	default[:metalprov][:dhcpd][:host_range] = "192.168.73.150 192.168.73.200"
	default[:metalprov][:dhcpd][:interfaces] = ['eth0']
	default[:metalprov][:dhcpd][:filename] = "pxelinux.0"

Usage
=====
	To run:

	knife node run_list add <node> recipe[metalprov::razor]

	Example: Deploying Ubuntu 12.0.4.1 - Create a model, policy, and attach to a Chef Broker for stage 3 (hand off).

	Once installed:

	1. sftp ubuntu-12.04.1-server-amd64.iso to /tmp
	2. razor -v -d image add -t os -p /tmp/ubuntu-12.04.1-server-amd64.iso -n ubuntu_precise -v 12.04
	3. razor model add -t ubuntu_precise -l install_precise -i <the UUID of the image>
	4. razor broker add -p chef -n Chef_1 -d Development (follow this -> http://anystacker.com/2012/12/razor-chef-broker-updated/)
	5. razor policy add -p linux_deploy -l precise -m <model UUID> -b <chef broker UUID> -t <tags: run razor node to get an example> -e true
	6. Power on the bare-metal!
	
	To update an existing policy to use a new Chef Broker.

	razor policy update <policy UUID> -l <policy lable> -m <model UUID> -b <broker UUID> 

	To get information:

	razor image (provides images)
	razor node (list of nodes)
	razor model (list of models)
	razor policy (list of policys)

	To troubleshoot:

	tail -f <path>/log/razor_daemon.log


License
========

	Author:: Velankani Engineering Team eng@velankani.net

	Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc.
	License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
