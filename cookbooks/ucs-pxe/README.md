Description
===========

A Chef cookbook (beta) that builds a PXE appliance for Cisco UCS bare-metal deployment. This cookbook acts as the stage 2 phase for DC Automation.
As of now, the recipes are tied specifically towards the workflow defined by ucs or ucs-solo cookbooks.

Requirements
============

The PXE appliance is currently tested on Ubuntu 12.04.1 LTS with at least 20G of disk space. Other platform OSs as well as target OS's will be supported 
in the future.



Supported Target OS and Hypervisor Environments:
	
	Ubuntu 12.04.1 LTS
	VMware ESX 5.1.0
	SuSE Enterprise Linux 11
	Debian 6.0.6 

	***Important note***
	The debian recipe builds a local debian mirror using debmirror. This requires close to 60G of disk space just for amd64. Please use this once you have a PXE node
	with sufficient disk space. Do this only once to be sensitive to bandwidth usage (of course)!


Limitations
============

At this time the PXE appliance is built per recipe. i.e for Ubuntu, SuSE, Esxi, Windows, etc. Multi-OS support will be implemented in
the future.


Attributes
==========

	#UCS
	default[:pxe][:ucs][:ip] = '192.168.73.131'
	default[:pxe][:ucs][:username] = 'admin'
	default[:pxe][:ucs][:password] = 'admin'


	#DHCP
	default[:pxe][:dhcpd][:dns_server] = "192.168.73.250"
	default[:pxe][:dhcpd][:next_server] = "192.168.73.136"
	default[:pxe][:dhcpd][:subnet] = "192.168.73.0"
	default[:pxe][:dhcpd][:subnet_mask] = "255.255.255.0"
	default[:pxe][:dhcpd][:broadcast] = "192.168.73.255"
	default[:pxe][:dhcpd][:gateway] = "192.168.73.1"
	default[:pxe][:dhcpd][:host_range] = "192.168.73.150 192.168.73.200"
	default[:pxe][:dhcpd][:interfaces] = ['eth0']
	default[:pxe][:dhcpd][:filename] = "pxelinux.0"
	default[:pxe][:dhcpd][:databag] = "dhcpd"


	#OS 
	default[:pxe][:preseed][:username] = "chef"
	default[:pxe][:preseed][:password] = "chef101"


	#OS/Hypervisor auth info 
	default[:pxe][:preseed][:username] = "chef"
	default[:pxe][:preseed][:password] = "chef101"


	# #Ubuntu
	# default[:pxe][:os][:release] = "ubuntu-12.04.1"
	# default[:pxe][:linux][:release][:dist] = "ubuntu-12.04.1"
	# default[:pxe][:linux][:release][:path] = "http://mirror.anl.gov/pub/ubuntu-iso/CDs/12.04/ubuntu-12.04.1-server-amd64.iso"

	# #Debian
	# default[:pxe][:os][:release] = "debian-6.0.5"
	# default[:pxe][:linux][:release][:dist] = "debian-6.0.5"
	# default[:pxe][:linux][:release][:path] = "http://ftp.debian.org/debian/dists/squeeze/main/installer-amd64/current/images/netboot/netboot.tar.gz"

	#ESXi - please rename VMware-VMvisor-Installer-5.1.0-799733.x86_64.iso to esxi-5.1.0.iso under /tmp
	# default[:pxe][:esxi][:release] = "esxi-5.1.0"
	# default[:pxe][:esxi][:path] = "http://example.com/VMware-VMvisor-Installer-5.1.0-799733.x86_64.iso"

	#Suse Linux
	default[:pxe][:os][:release] = "SLES-11-SP2"
	default[:pxe][:linux][:release][:dist] = "SLES-11-SP2"
	default[:pxe][:linux][:release][:path] = "http://example.com/SLES-11-SP2-DVD-x86_64-GM-DVD1.iso"

Usage
=====

Follows a convention. include_recipe considered harmful and therefore we do not use it as part of our philosophy. 
We prefer more explicit ways to do things forcing us to declare all dependencies when orchestrating.

The run_list order using knife:

	1. Install packages

	knife node run_list add <node> recipe[ucs-pxe::default]
	knife ssh name:<node> -x <username> -P <password> "sudo chef-client"

	2. Setup the databags needed for generating the custom dhcpd.conf

	knife node run_list remove <node> recipe[ucs-pxe::default]
	knife node run_list add <node> recipe[ucs-pxe::databag]
	knife ssh name:<node> -x <username> -P <password> "sudo chef-client"

	3. Setup dhcpd.conf based on mac addresses of all assigned service profiles

	knife node run_list remove <node> recipe[ucs-pxe::databag]
	knife node run_list add <node> recipe[ucs-pxe::dhcpd]
	knife ssh name:<node> -x <username> -P <password> "sudo chef-client"

	4. Build target OS environment to be deployed.

	knife node run_list remove <node> recipe[ucs-pxe::dhcpd]
	knife node run_list add <node> recipe[ucs-pxe::ubuntu]
	knife ssh name:<node> -x <username> -P <password> "sudo chef-client"

	5. Reboot Service Profile(s). The install should begin.

	6. The system halts after installation is complete.


ToDo
=====

1. Reciple for toggling boot policy to boot from disk to move towards Stage 3 - service provisioning.

License
========

	Author:: Velankani Engineering Team eng@velankani.net

	Copyright:: Copyright (c) 2011 Murali Raju, murali.raju@appliv.com
	Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc.
	License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.






