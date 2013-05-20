Description
===========

A Chef cookbook (beta) to deploy and configure Cisco UCS. The cookbook leverages chef-solo with ucslib and helps setup
a basic Cisco UCS deployment. It acts as a template to highlight what's possible with the UCS API.



Requirements
============

On Ubuntu 12.04, Debian 6 or Mac OS X 10.8.2, install Ruby 1.9.3. RVM is recommended - http://rvm.io

On Ubuntu:

	apt-get install ruby1.9.3
	sudo gem install chef --no-ri --no-rdoc 

*Future iterations will have a distributed setup using chef-server


Attributes
==========

Attributes are only used for auth info (for now):

default[:ucs][:ip] = '<ip>'
default[:ucs][:username] = '<username>'
default[:ucs][:password] = '<password>'

This cookbook uses data bags for feeding UCS config parameters.

Usage
=====

**The following is a sample setup.


Edit /etc/chef/solo.rb:

	cookbook_path "/etc/chef/cookbooks"
	file_cache_path "/etc/chef-solo" #Default
	role_path "/etc/chef-solo/roles" #Default
	data_bag_path "/etc/chef-solo/data_bags" #Default
	json_attribs "/etc/chef/node.json" #Also not default


Edit /etc/chef/install.json:

chef@chef-solo:~$sudo cat /etc/chef/install.json 
{
"run_list" : ["recipe[ucs-solo::default]"]
            
}
chef@chef-solo:~$


Edit /etc/chef/run.json:

chef@dev:~$sudo cat /etc/chef/run.json

	{
	"run_list" : [ 
			      "recipe[ucs-solo::initials]",
			      "recipe[ucs-solo::firmware]",
			      "recipe[ucs-solo::ports]",
			      "recipe[ucs-solo::policies]",
			      "recipe[ucs-solo::pools]",
			      "recipe[ucs-solo::network]",
			      "recipe[ucs-solo::storage]",
			      "recipe[ucs-solo::templates]",
			      "recipe[ucs-solo::serviceprofiles]",
			      "recipe[ucs-solo::manage]"
			    ]
	}

chef@dev:~$




To install packages:

	chef@chef-solo:~$ sudo chef-solo -j /etc/chef/install.json 
	[2012-11-21T11:12:49-05:00] INFO: *** Chef 10.16.2 ***
	[2012-11-21T11:12:49-05:00] INFO: Setting the run_list to ["recipe[ucs-solo::default]"] from JSON
	[2012-11-21T11:12:49-05:00] INFO: Run List is [recipe[ucs-solo::default]]
	[2012-11-21T11:12:49-05:00] INFO: Run List expands to [ucs-solo::default]
	[2012-11-21T11:12:49-05:00] INFO: Starting Chef Run for chef-solo
	[2012-11-21T11:12:49-05:00] INFO: Running start handlers
	[2012-11-21T11:12:49-05:00] INFO: Start handlers complete.
	[2012-11-21T11:12:49-05:00] INFO: Processing package[libxml2-dev] action install (ucs-solo::default line 21)
	[2012-11-21T11:12:52-05:00] INFO: Processing package[libxslt1-dev] action install (ucs-solo::default line 22)
	[2012-11-21T11:12:55-05:00] INFO: Processing gem_package[ucslib] action install (ucs-solo::default line 23)
	[2012-11-21T11:13:07-05:00] INFO: Processing log[Installation of ucslib and dependencies] action write (ucs-solo::default line 25)
	[2012-11-21T11:13:07-05:00] INFO: Installation of ucslib and dependencies
	[2012-11-21T11:13:07-05:00] INFO: Chef Run complete in 17.577065844 seconds
	[2012-11-21T11:13:07-05:00] INFO: Running report handlers
	[2012-11-21T11:13:07-05:00] INFO: Report handlers complete

To run recipes:

	chef@chef-solo:~$ sudo chef-solo -j /etc/chef/run.json 
	[2012-11-21T11:13:16-05:00] INFO: *** Chef 10.16.2 ***
	[2012-11-21T11:13:16-05:00] INFO: Setting the run_list to ["recipe[ucs-solo::initials]", "recipe[ucs-solo::firmware]", "recipe[ucs-solo::ports]", "recipe[ucs-solo::policies]", "recipe[ucs-solo::pools]", "recipe[ucs-solo::network]", "recipe[ucs-solo::storage]", "recipe[ucs-solo::templates]", "recipe[ucs-solo::serviceprofiles]", "recipe[ucs-solo::manage]"] from JSON
	[2012-11-21T11:13:16-05:00] INFO: Run List is [recipe[ucs-solo::initials], recipe[ucs-solo::firmware], recipe[ucs-solo::ports], recipe[ucs-solo::policies], recipe[ucs-solo::pools], recipe[ucs-solo::network], recipe[ucs-solo::storage], recipe[ucs-solo::templates], recipe[ucs-solo::serviceprofiles], recipe[ucs-solo::manage]]
	[2012-11-21T11:13:16-05:00] INFO: Run List expands to [ucs-solo::initials, ucs-solo::firmware, ucs-solo::ports, ucs-solo::policies, ucs-solo::pools, ucs-solo::network, ucs-solo::storage, ucs-solo::templates, ucs-solo::serviceprofiles, ucs-solo::manage]
	[2012-11-21T11:13:16-05:00] INFO: Starting Chef Run for chef-solo
	[2012-11-21T11:13:16-05:00] INFO: Running start handlers
	[2012-11-21T11:13:16-05:00] INFO: Start handlers complete.
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"ntp_server":"192.168.207.250"}] action write (ucs-solo::initials line 67)
	[2012-11-21T11:13:26-05:00] INFO: {"ntp_server":"192.168.207.250"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"ntp_server":"192.168.207.251"}] action write (ucs-solo::initials line 67)
	[2012-11-21T11:13:26-05:00] INFO: {"ntp_server":"192.168.207.251"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"time_zone":"America/New_York"}] action write (ucs-solo::initials line 71)
	[2012-11-21T11:13:26-05:00] INFO: {"time_zone":"America/New_York"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"power_policy":"grid"}] action write (ucs-solo::initials line 74)
	[2012-11-21T11:13:26-05:00] INFO: {"power_policy":"grid"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"chassis_discovery_policy":"4-link"}] action write (ucs-solo::initials line 77)
	[2012-11-21T11:13:26-05:00] INFO: {"chassis_discovery_policy":"4-link"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"local_disk_policy":"any-configuration"}] action write (ucs-solo::initials line 80)
	[2012-11-21T11:13:26-05:00] INFO: {"local_disk_policy":"any-configuration"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"start_ip":"10.10.1.5","end_ip":"10.10.1.10","subnet_mask":"255.255.255.0","gateway":"10.10.1.1"}] action write (ucs-solo::initials line 83)
	[2012-11-21T11:13:26-05:00] INFO: {"start_ip":"10.10.1.5","end_ip":"10.10.1.10","subnet_mask":"255.255.255.0","gateway":"10.10.1.1"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"org":"HR","description":"HR Organization"}] action write (ucs-solo::initials line 92)
	[2012-11-21T11:13:26-05:00] INFO: {"org":"HR","description":"HR Organization"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"org":"IT","description":"IT Organization"}] action write (ucs-solo::initials line 92)
	[2012-11-21T11:13:26-05:00] INFO: {"org":"IT","description":"IT Organization"}
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for N20-AC0002] action write (ucs-solo::firmware line 66)
	[2012-11-21T11:13:26-05:00] INFO: Created Host Firmware Package vdi-fw for N20-AC0002
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for B230-BASE-M2] action write (ucs-solo::firmware line 66)
	[2012-11-21T11:13:26-05:00] INFO: Created Host Firmware Package vdi-fw for B230-BASE-M2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for B230-BASE-M2] action write (ucs-solo::firmware line 66)
	[2012-11-21T11:13:26-05:00] INFO: Created Host Firmware Package vdi-fw for B230-BASE-M2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for N20-AE0002] action write (ucs-solo::firmware line 66)
	[2012-11-21T11:13:26-05:00] INFO: Created Host Firmware Package vdi-fw for N20-AE0002
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for N20-AQ0002] action write (ucs-solo::firmware line 66)
	[2012-11-21T11:13:26-05:00] INFO: Created Host Firmware Package vdi-fw for N20-AQ0002
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Mgmt Firmware Package vdi-fw for B230-BASE-M2] action write (ucs-solo::firmware line 87)
	[2012-11-21T11:13:26-05:00] INFO: Created Mgmt Firmware Package vdi-fw for B230-BASE-M2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 1 on Switch A and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 1 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 2 on Switch A and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 2 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 3 on Switch A and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 3 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 4 on Switch A and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 4 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 1 on Switch B and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 1 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 2 on Switch B and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 2 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 3 on Switch B and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 3 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created port 4 on Switch B and Slot 1] action write (ucs-solo::ports line 58)
	[2012-11-21T11:13:26-05:00] INFO: Created port 4 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Port Channel PortChannel30 ID 30 on Switch A and Slot 1] action write (ucs-solo::ports line 76)
	[2012-11-21T11:13:26-05:00] INFO: Created Port Channel PortChannel30 ID 30 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Port Channel PortChannel31 ID 31 on Switch B and Slot 1] action write (ucs-solo::ports line 76)
	[2012-11-21T11:13:26-05:00] INFO: Created Port Channel PortChannel31 ID 31 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Uplink Port 31 on Switch A and Slot 1] action write (ucs-solo::ports line 98)
	[2012-11-21T11:13:26-05:00] INFO: Created Uplink Port 31 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Uplink Port 32 on Switch A and Slot 1] action write (ucs-solo::ports line 98)
	[2012-11-21T11:13:26-05:00] INFO: Created Uplink Port 32 on Switch A and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Uplink Port 31 on Switch B and Slot 1] action write (ucs-solo::ports line 98)
	[2012-11-21T11:13:26-05:00] INFO: Created Uplink Port 31 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Uplink Port 32 on Switch B and Slot 1] action write (ucs-solo::ports line 98)
	[2012-11-21T11:13:26-05:00] INFO: Created Uplink Port 32 on Switch B and Slot 1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 1 on Switch A and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 1 on Switch A and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 2 on Switch A and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 2 on Switch A and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 3 on Switch A and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 3 on Switch A and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 4 on Switch A and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 4 on Switch A and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 1 on Switch B and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 1 on Switch B and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 2 on Switch B and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 2 on Switch B and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 3 on Switch B and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 3 on Switch B and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created FC Uplink Port 4 on Switch B and Slot 2] action write (ucs-solo::ports line 123)
	[2012-11-21T11:13:26-05:00] INFO: Created FC Uplink Port 4 on Switch B and Slot 2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created SAN boot policy SANBoot in org IT] action write (ucs-solo::policies line 63)
	[2012-11-21T11:13:26-05:00] INFO: Created SAN boot policy SANBoot in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created local boot policy LocalBoot in org IT] action write (ucs-solo::policies line 67)
	[2012-11-21T11:13:26-05:00] INFO: Created local boot policy LocalBoot in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created PXE boot policy PXEBoot in org IT] action write (ucs-solo::policies line 71)
	[2012-11-21T11:13:26-05:00] INFO: Created PXE boot policy PXEBoot in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created UUID Pool vdi-uuid from 0000-000000000001 to 0000-000000000020 in org IT] action write (ucs-solo::pools line 67)
	[2012-11-21T11:13:26-05:00] INFO: Created UUID Pool vdi-uuid from 0000-000000000001 to 0000-000000000020 in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created MAC Pool vdi-mac start 00:25:B5:00:00:00 end 00:25:B5:00:00:1F in org IT] action write (ucs-solo::pools line 68)
	[2012-11-21T11:13:26-05:00] INFO: Created MAC Pool vdi-mac start 00:25:B5:00:00:00 end 00:25:B5:00:00:1F in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created WWPN Pool vdi-wwpn from 20:00:00:25:B5:01:00:00 to 20:00:00:25:B5:01:00:3F in org IT] action write (ucs-solo::pools line 69)
	[2012-11-21T11:13:26-05:00] INFO: Created WWPN Pool vdi-wwpn from 20:00:00:25:B5:01:00:00 to 20:00:00:25:B5:01:00:3F in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created WWNN Pool vdi-wwnn from 20:00:00:25:B5:00:00:00 to 20:00:00:25:B5:00:00:3F in org IT] action write (ucs-solo::pools line 70)
	[2012-11-21T11:13:26-05:00] INFO: Created WWNN Pool vdi-wwnn from 20:00:00:25:B5:00:00:00 to 20:00:00:25:B5:00:00:3F in org IT
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created Server Pool VDI on chassis 1 using blades 1,3,4,2] action write (ucs-solo::pools line 71)
	[2012-11-21T11:13:26-05:00] INFO: Created Server Pool VDI on chassis 1 using blades 1,3,4,2
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created VLAN IT with ID 100] action write (ucs-solo::network line 50)
	[2012-11-21T11:13:26-05:00] INFO: Created VLAN IT with ID 100
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created VLAN HR with ID 200] action write (ucs-solo::network line 50)
	[2012-11-21T11:13:26-05:00] INFO: Created VLAN HR with ID 200
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created VSAN vsan100 with ID 100] action write (ucs-solo::storage line 51)
	[2012-11-21T11:13:26-05:00] INFO: Created VSAN vsan100 with ID 100
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created VSAN vsan200 with ID 200] action write (ucs-solo::storage line 51)
	[2012-11-21T11:13:26-05:00] INFO: Created VSAN vsan200 with ID 200
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created  vNIC Template VDI-A] action write (ucs-solo::templates line 56)
	[2012-11-21T11:13:26-05:00] INFO: Created  vNIC Template VDI-A
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created  vNIC Template VDI-B] action write (ucs-solo::templates line 56)
	[2012-11-21T11:13:26-05:00] INFO: Created  vNIC Template VDI-B
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created  vHBA Template VDI-A] action write (ucs-solo::templates line 75)
	[2012-11-21T11:13:26-05:00] INFO: Created  vHBA Template VDI-A
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created  vHBA Template VDI-B] action write (ucs-solo::templates line 75)
	[2012-11-21T11:13:26-05:00] INFO: Created  vHBA Template VDI-B
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created  Service Profile Template VDI-Template-1] action write (ucs-solo::templates line 104)
	[2012-11-21T11:13:26-05:00] INFO: Created  Service Profile Template VDI-Template-1
	[2012-11-21T11:13:26-05:00] INFO: Processing log[Created  Service Profiles SampleVDI01,SampleVDI02,SampleVDI03] action write (ucs-solo::serviceprofiles line 65)
	[2012-11-21T11:13:26-05:00] INFO: Created  Service Profiles SampleVDI01,SampleVDI02,SampleVDI03
	[2012-11-21T11:13:26-05:00] INFO: Processing log[{"service_profile_boot_policy":"PXEBoot","service_profile_host_fw_policy":"vdi-fw","service_profile_mgmt_fw_policy":"vdi-fw","service_profile_uuid_pool":"vdi-uuid","service_profile_template_to_bind":"VDI-Template-1","service_profile_server_pool":"VDI","org":"IT"}] action write (ucs-solo::manage line 54)
	[2012-11-21T11:13:26-05:00] INFO: {"service_profile_boot_policy":"PXEBoot","service_profile_host_fw_policy":"vdi-fw","service_profile_mgmt_fw_policy":"vdi-fw","service_profile_uuid_pool":"vdi-uuid","service_profile_template_to_bind":"VDI-Template-1","service_profile_server_pool":"VDI","org":"IT"}
	[2012-11-21T11:13:26-05:00] INFO: Chef Run complete in 10.259353197 seconds
	[2012-11-21T11:13:26-05:00] INFO: Running report handlers
	[2012-11-21T11:13:26-05:00] INFO: Report handlers complete
	rajum@chef-solo:~$ 
	
====

1. Move authentication info to encrypted Data Bags. Currently uses attributes.


License

	Author:: Velankani Engineering Team eng@velankani.net

	Copyright:: Copyright (c) 2011 Murali Raju, murali.raju@appliv.com
	Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc.

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

