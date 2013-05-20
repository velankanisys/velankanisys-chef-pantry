Description
===========

A Cookbook to setup a development environment to work with Big Data. Current features:

* Setup a Cloudera (CHD4) Hadoop and HBase environment in pseudo distributed mode
* Setup a HortonWorks (HDP1.2) Hadoop environment in pseudo distributed mode

Requirements
============

An Ubuntu 12.0.4 LTS machine with at least 1G of RAM and 20G of disk space.

Attributes
==========

	#Hadoop
	default[:bigdatadev][:hadoop][:dist] = "cdh4"
	default[:bigdatadev][:hadoop][:path] = "http://archive.cloudera.com/cdh4/one-click-install/precise/amd64/cdh4-repository_1.0_all.deb"
	default[:bigdatadev][:hadoop][:java_home] = "/usr/lib/jvm/jdk1.6.0_37"
	default[:bigdatadev][:hadoop][:user] = "cdhuser"

	#HBase
	default[:bigdatadev][:hbase][:dir] = "hbase"
	default[:bigdatadev][:hbase][:user] = "hbaseuser"


Usage
=====

Create a a role that contains "recipe[bigdatadev::hadoop_pseudo_dist]" and "recipe[bigdatadev::hbase_pseudo_dist]" and apply it a node.

Example:

	chef_type:            role
	default_attributes:   {}
	description:          
	env_run_lists:        {}
	json_class:           Chef::Role
	name:                 bigdatadev
	override_attributes:  {}
	run_list:            
	    recipe[bigdatadev::hadoop_pseudo_dist]
	    recipe[bigdatadev::hbase_pseudo_dist]


License
========

	Author:: Velankani Engineering Team eng@velankani.net

	Copyright:: Copyright (c) 2012 Velankani Information Systems, Inc.
	License:: Apache License, Version 2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0 Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
