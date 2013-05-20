#
# Cookbook Name:: pxe
# Recipe:: data_bags [Generate data_bags for use by recipe pxe::dhcpd]
# Notes: This recipe is for Cisco UCS only as it relies no querying assigned
#        MAC addresses on all Service Profiles
#
# Copyright 2012, Murali Raju, murali.raju@appliv.com
# Copyright 2012, Velankani Information Systems, eng@velankani.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ucs-pxe::ntp"

require 'ucslib'
#Uncomment to debug
#log "Using: #{node[:ucs][:ip]}, #{node[:ucs][:username]}, #{node[:ucs][:password]}"

#JSON Definitions Start
auth_json = {:ip => "#{node[:pxe][:ucs][:ip]}",
             :username => "#{node[:pxe][:ucs][:username]}",
             :password => "#{node[:pxe][:ucs][:password]}"}.to_json

#JSON Definitions End

#Initialize Objects
ucs_session = UCSToken.new
token_json = ucs_session.get_token(auth_json)
@ucs_manager = UCSManage.new(token_json)
#Uncomment to debug
#log token_json


# There seems to be a problem using the DataBag objects within a recipe
# using data_bag.save. Using data_bag.create until fix. This version is not robust
# in terms of checking for existing data bags. Use knife commands to delete
# existing data bags before running this recipe

data_bag_name = "#{node[:pxe][:dhcpd][:databag]}"


def create_data_bag(data_bag_name)
	data_bag = Chef::DataBag.new
	data_bag.name(data_bag_name)
	data_bag.create
end


def create_data_bag_items(data_bag_name)
	host_range = node[:pxe][:dhcpd][:host_range].split()
	first_3_octets_start_ip = "#{host_range[0].split('.')[0]}"+"." \
							  +"#{host_range[0].split('.')[1]}"+"." \
							  +"#{host_range[0].split('.')[2]}"+"."	
	start_ip_last_octet = host_range[0].split('.')[3].to_i
	end_ip_last_octet = host_range[1].split('.')[3].to_i

	
	initial_last_octet = start_ip_last_octet
	state = @ucs_manager.discover_state
	state.xpath("configResolveClasses/outConfigs/macpoolPooled").each do |macpool|
		#Check if service profile is assigned and we only select the vNIC A Mac address
		if "#{macpool.attributes["assigned"]}" == 'yes' and "#{macpool.attributes["assignedToDn"].to_s.scan(/ether-vNIC-(\w+)/)}" == '[["A"]]'
			extracted_service_profile_name = "#{macpool.attributes["assignedToDn"]}"
			service_profile_names = extracted_service_profile_name.to_s.scan(/ls-(\w+)/)
			service_profile_names.each do |name|
				hosts_names = name
				hosts_names.each do |host_name|
					@host = host_name.downcase
					serviceprofile = {
					  "id" => @host,
					  "mac_address" => "#{macpool.attributes["id"]}",
					  "ip" => "#{first_3_octets_start_ip}"+"#{initial_last_octet}",
					  "gateway" => "#{node[:pxe][:dhcpd][:gateway]}",
					  "mask" => "#{node[:pxe][:dhcpd][:subnet_mask]}",
					  "broadcast" => "#{node[:pxe][:dhcpd][:broadcast]}",
					  "host_name" => @host
					}	
					databag_item = Chef::DataBagItem.new
					databag_item.data_bag(data_bag_name)
					databag_item.raw_data = serviceprofile 
					databag_item.create
				end
			end
		else
			puts "Skipping mac address #{macpool.attributes["id"]}"
		end
		initial_last_octet += 1
	end	
end


def run(data_bag_name)
	create_data_bag(data_bag_name)
	create_data_bag_items(data_bag_name)
end

run(data_bag_name)
