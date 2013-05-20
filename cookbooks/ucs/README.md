Description
===========

A Chef cookbook (beta) to deploy and configure Cisco UCS. The cookbook leverages Chef Server, a chef-node (UCS Proxy) with ucslib and helps setup a basic Cisco UCS deployment. It acts as a template to highlight what's possible with the UCS API using Chef in a distributed environment.


Requirements
============

1. Chef Server - Either hosted or local http://wiki.opscode.com/display/chef/Chef+Server
2. Chef workstation - Mac OS X or Linux
3. A Chef node that abstracts and acts as a proxy for chef-client runs for UCS


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

Assuming knife.rb is setup on the Chef Workstation:

1. Create and upload the data bags by running './create_data_bags.sh'
2. Upload the ucs cookbook by running:
	knife cookbook upload ucs

	Uploading ucs            [0.0.1]
	Uploaded 1 cookbook.

3. Bootstrap the ucs proxy chef node (in this example the node is an Ubuntu 12.04 machine) by running:

	knife bootstrap chef-ucsnode -x chef -P chef101 --sudo

	If successful, the output should look similar to:

		chef-ucsnode 57365 files and directories currently installed.)
		chef-ucsnode 
		chef-ucsnode Unpacking chef (from .../chef_10.16.2_amd64.deb) ...
		chef-ucsnode 
		chef-ucsnode Setting up chef (10.16.2-1.ubuntu.11.04) ...
		chef-ucsnode 
		chef-ucsnode Thank you for installing Chef!
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:31-05:00] INFO: *** Chef 10.16.2 ***
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:31-05:00] INFO: Client key /etc/chef/client.pem is not present - registering
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: HTTP Request Returned 404 Not Found: Cannot load node chef-ucsnode
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Setting the run_list to [] from JSON
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Run List is []
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Run List expands to []
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: HTTP Request Returned 404 Not Found: No routes match the request: /reports/nodes/chef-ucsnode/runs
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Starting Chef Run for chef-ucsnode
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Running start handlers
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Start handlers complete.
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] INFO: Loading cookbooks []
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:32-05:00] WARN: Node chef-ucsnode has an empty run list.
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:33-05:00] INFO: Chef Run complete in 0.966651101 seconds
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:33-05:00] INFO: Running report handlers
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:28:33-05:00] INFO: Report handlers complete
		chef-ucsnode 

4. Add recipes to run_list and run chef-client:

	a. First install ucslib and dependencies by running:

	knife node run_list add chef-ucsnode recipe[ucs::default]

	knife ssh name:chef-ucsnode -u chef -P chef101 "sudo chef-client"

	If successful, the chef-client run should end with:

		-----snippet----
		chef-ucsnode [2012-11-21T13:42:26-05:00] INFO: Processing package[libxml2-dev] action install (ucs::default line 21)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:29-05:00] INFO: Processing package[libxslt1-dev] action install (ucs::default line 22)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:31-05:00] INFO: Processing gem_package[ucslib] action install (ucs::default line 23)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:41-05:00] INFO: Processing log[Installation of ucslib and dependencies] action write (ucs::default line 25)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:41-05:00] INFO: Installation of ucslib and dependencies
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:42-05:00] INFO: Chef Run complete in 19.194063737 seconds
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:42-05:00] INFO: Running report handlers
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:42:42-05:00] INFO: Report handlers complete


	b. Add the remaining recipes in the following order to complete the chef-client run:

	knife node run_list add chef-ucsnode recipe[ucs::"recipe"]

		run_list: 
		    recipe[ucs::default]
		    recipe[ucs::initials]
		    recipe[ucs::firmware]
		    recipe[ucs::ports]
		    recipe[ucs::policies]
		    recipe[ucs::pools]
		    recipe[ucs::network]
		    recipe[ucs::storage]
		    recipe[ucs::templates]
		    recipe[ucs::serviceprofiles]
		    recipe[ucs::manage]


	knife ssh name:chef-ucsnode -u chef -P chef101 "sudo chef-client"
	
	If successful, the output should look like the following. Check UCS Manager GUI to confirm!

		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:29-05:00] INFO: *** Chef 10.16.2 ***
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:29-05:00] INFO: Run List is [recipe[ucs::default], recipe[ucs::initials], recipe[ucs::firmware], recipe[ucs::ports], recipe[ucs::policies], recipe[ucs::pools], recipe[ucs::network], recipe[ucs::storage], recipe[ucs::templates], recipe[ucs::serviceprofiles], recipe[ucs::manage]]
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:29-05:00] INFO: Run List expands to [ucs::default, ucs::initials, ucs::firmware, ucs::ports, ucs::policies, ucs::pools, ucs::network, ucs::storage, ucs::templates, ucs::serviceprofiles, ucs::manage]
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:30-05:00] INFO: HTTP Request Returned 404 Not Found: No routes match the request: /reports/nodes/chef-ucsnode/runs
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:30-05:00] INFO: Starting Chef Run for chef-ucsnode
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:30-05:00] INFO: Running start handlers
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:30-05:00] INFO: Start handlers complete.
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:30-05:00] INFO: Loading cookbooks [ucs]
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:44-05:00] INFO: Processing package[libxml2-dev] action install (ucs::default line 21)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:44-05:00] INFO: Processing package[libxslt1-dev] action install (ucs::default line 22)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:44-05:00] INFO: Processing gem_package[ucslib] action install (ucs::default line 23)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Installation of ucslib and dependencies] action write (ucs::default line 25)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Installation of ucslib and dependencies
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"ntp_server":"192.168.207.250"}] action write (ucs::initials line 67)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"ntp_server":"192.168.207.250"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"ntp_server":"192.168.207.251"}] action write (ucs::initials line 67)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"ntp_server":"192.168.207.251"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"time_zone":"America/New_York"}] action write (ucs::initials line 71)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"time_zone":"America/New_York"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"power_policy":"grid"}] action write (ucs::initials line 74)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"power_policy":"grid"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"chassis_discovery_policy":"4-link"}] action write (ucs::initials line 77)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"chassis_discovery_policy":"4-link"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"local_disk_policy":"any-configuration"}] action write (ucs::initials line 80)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"local_disk_policy":"any-configuration"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"start_ip":"10.10.1.5","end_ip":"10.10.1.10","subnet_mask":"255.255.255.0","gateway":"10.10.1.1"}] action write (ucs::initials line 83)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"start_ip":"10.10.1.5","end_ip":"10.10.1.10","subnet_mask":"255.255.255.0","gateway":"10.10.1.1"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"org":"HR","description":"HR Organization"}] action write (ucs::initials line 92)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"org":"HR","description":"HR Organization"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"org":"IT","description":"IT Organization"}] action write (ucs::initials line 92)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"org":"IT","description":"IT Organization"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for N20-AQ0002] action write (ucs::firmware line 66)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Host Firmware Package vdi-fw for N20-AQ0002
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for N20-AE0002] action write (ucs::firmware line 66)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Host Firmware Package vdi-fw for N20-AE0002
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for B230-BASE-M2] action write (ucs::firmware line 66)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Host Firmware Package vdi-fw for B230-BASE-M2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for N20-AC0002] action write (ucs::firmware line 66)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Host Firmware Package vdi-fw for N20-AC0002
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Host Firmware Package vdi-fw for B230-BASE-M2] action write (ucs::firmware line 66)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Host Firmware Package vdi-fw for B230-BASE-M2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Mgmt Firmware Package vdi-fw for B230-BASE-M2] action write (ucs::firmware line 87)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Mgmt Firmware Package vdi-fw for B230-BASE-M2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 1 on Switch A and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 1 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 2 on Switch A and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 2 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 3 on Switch A and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 3 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 4 on Switch A and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 4 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 1 on Switch B and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 1 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 2 on Switch B and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 2 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 3 on Switch B and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 3 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created port 4 on Switch B and Slot 1] action write (ucs::ports line 58)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created port 4 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Port Channel PortChannel30 ID 30 on Switch A and Slot 1] action write (ucs::ports line 76)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Port Channel PortChannel30 ID 30 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Port Channel PortChannel31 ID 31 on Switch B and Slot 1] action write (ucs::ports line 76)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Port Channel PortChannel31 ID 31 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Uplink Port 31 on Switch A and Slot 1] action write (ucs::ports line 98)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Uplink Port 31 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Uplink Port 32 on Switch A and Slot 1] action write (ucs::ports line 98)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Uplink Port 32 on Switch A and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Uplink Port 31 on Switch B and Slot 1] action write (ucs::ports line 98)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Uplink Port 31 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Uplink Port 32 on Switch B and Slot 1] action write (ucs::ports line 98)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Uplink Port 32 on Switch B and Slot 1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 1 on Switch A and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 1 on Switch A and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 2 on Switch A and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 2 on Switch A and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 3 on Switch A and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 3 on Switch A and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 4 on Switch A and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 4 on Switch A and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 1 on Switch B and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 1 on Switch B and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 2 on Switch B and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 2 on Switch B and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 3 on Switch B and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 3 on Switch B and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created FC Uplink Port 4 on Switch B and Slot 2] action write (ucs::ports line 123)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created FC Uplink Port 4 on Switch B and Slot 2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created SAN boot policy SANBoot in org IT] action write (ucs::policies line 63)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created SAN boot policy SANBoot in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created local boot policy LocalBoot in org IT] action write (ucs::policies line 67)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created local boot policy LocalBoot in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created PXE boot policy PXEBoot in org IT] action write (ucs::policies line 71)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created PXE boot policy PXEBoot in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created UUID Pool vdi-uuid from 0000-000000000001 to 0000-000000000020 in org IT] action write (ucs::pools line 67)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created UUID Pool vdi-uuid from 0000-000000000001 to 0000-000000000020 in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created MAC Pool vdi-mac start 00:25:B5:00:00:00 end 00:25:B5:00:00:1F in org IT] action write (ucs::pools line 68)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created MAC Pool vdi-mac start 00:25:B5:00:00:00 end 00:25:B5:00:00:1F in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created WWPN Pool vdi-wwpn from 20:00:00:25:B5:01:00:00 to 20:00:00:25:B5:01:00:3F in org IT] action write (ucs::pools line 69)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created WWPN Pool vdi-wwpn from 20:00:00:25:B5:01:00:00 to 20:00:00:25:B5:01:00:3F in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created WWNN Pool vdi-wwnn from 20:00:00:25:B5:00:00:00 to 20:00:00:25:B5:00:00:3F in org IT] action write (ucs::pools line 70)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created WWNN Pool vdi-wwnn from 20:00:00:25:B5:00:00:00 to 20:00:00:25:B5:00:00:3F in org IT
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created Server Pool VDI on chassis 1 using blades 1,3,4,2] action write (ucs::pools line 71)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created Server Pool VDI on chassis 1 using blades 1,3,4,2
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created VLAN IT with ID 100] action write (ucs::network line 50)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created VLAN IT with ID 100
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created VLAN HR with ID 200] action write (ucs::network line 50)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created VLAN HR with ID 200
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created VSAN vsan100 with ID 100] action write (ucs::storage line 51)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created VSAN vsan100 with ID 100
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created VSAN vsan200 with ID 200] action write (ucs::storage line 51)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created VSAN vsan200 with ID 200
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created  vNIC Template VDI-B] action write (ucs::templates line 56)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created  vNIC Template VDI-B
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created  vNIC Template VDI-A] action write (ucs::templates line 56)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created  vNIC Template VDI-A
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created  vHBA Template VDI-A] action write (ucs::templates line 75)
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created  vHBA Template VDI-A
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created  vHBA Template VDI-B] action write (ucs::templates line 75)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created  vHBA Template VDI-B
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created  Service Profile Template VDI-Template-1] action write (ucs::templates line 104)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created  Service Profile Template VDI-Template-1
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[Created  Service Profiles SampleVDI01,SampleVDI02,SampleVDI03] action write (ucs::serviceprofiles line 65)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Created  Service Profiles SampleVDI01,SampleVDI02,SampleVDI03
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Processing log[{"service_profile_boot_policy":"PXEBoot","service_profile_host_fw_policy":"vdi-fw","service_profile_mgmt_fw_policy":"vdi-fw","service_profile_uuid_pool":"vdi-uuid","service_profile_template_to_bind":"VDI-Template-1","service_profile_server_pool":"VDI","org":"IT"}] action write (ucs::manage line 54)
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: {"service_profile_boot_policy":"PXEBoot","service_profile_host_fw_policy":"vdi-fw","service_profile_mgmt_fw_policy":"vdi-fw","service_profile_uuid_pool":"vdi-uuid","service_profile_template_to_bind":"VDI-Template-1","service_profile_server_pool":"VDI","org":"IT"}
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Chef Run complete in 15.78688605 seconds
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Running report handlers
		chef-ucsnode 
		chef-ucsnode [2012-11-21T13:49:45-05:00] INFO: Report handlers complete
		chef-ucsnode  


License

	Author:: Velankani Engineering Team eng@velankani.net

	Copyright:: Copyright (c) 2011 Murali Raju, murali.raju@appliv.com
	Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc.

License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

