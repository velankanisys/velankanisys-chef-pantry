Description
===========

This cookbook that sets up an Automator node (Orchestration) or a VM in a laptop based on Debian Squeeze. The orchestration and command dispatch is 
powered by Rundeck with chef-solo and the Velankani Chef Cookbooks. 

Requirements
============

A Debian Squeeze (6.0.6) node either using ucx-pxe or a manual setup.


Attributes
==========

	#Current supported platform - Debian Squeeze
	#Orchestrator
	default[:automator][:orchestrator][:dist] = "rundeck-1.4.4"
	default[:automator][:orchestrator][:path] = "https://s3.amazonaws.com/velankanidownloads/rundeck-1.4.4.deb"
	default[:automator][:orchestrator][:cookbooks_path] = "https://github.com/velankanisys/chef-cookbooks/archive/master.tar.gz"
	default[:automator][:orchestrator][:cookbooks] = "velankanisys-chef-cookbooks"
	default[:automator][:orchestrator][:data_bags] = "/etc/chef/chef-cookbooks-master/ucs-solo/data_bags"

Usage
=====

	knife bootstrap <node name> -x root -P <password>
	knife node run_list add <node_name> recipe[automator::builder]
	knife ssh name:<node name> -x root -P <password> "chef-client"

	Login to rundeck using http://<node name>:4440 with username: admin password: admin

License
======


	Author:: Velankani Engineering Team eng@velankani.net

	Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc.
	License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

