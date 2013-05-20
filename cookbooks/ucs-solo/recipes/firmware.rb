#
# Cookbook Name:: ucs
# Recipe:: basic [Setup Basic Environment]
#
# Copyright 2011, Murali Raju, murali.raju@appliv.com
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

#include_recipe 'ucs::basic'

require 'ucslib'

#Uncomment to debug
#log "Using: #{node[:ucs][:ip]}, #{node[:ucs][:username]}, #{node[:ucs][:password]}"

#JSON Definitions Start
auth_json = {:ip => "#{node[:ucs][:ip]}",
             :username => "#{node[:ucs][:username]}",
             :password => "#{node[:ucs][:password]}"}.to_json

#JSON Definitions End

#Initialize Objects
ucs_session = UCSToken.new
token_json = ucs_session.get_token(auth_json)
ucs_provision = UCSProvision.new(token_json)
#Uncomment to debug
#log token_json

#Set Host Firmware Package for multiple devices - device1.json, device2.json data bags.

hostfirmwares = data_bag("hostfirmwares")
counter = 0
hostfirmwares.each do |hostfirmware_info|

  hostfirmware = data_bag_item("hostfirmwares", hostfirmware_info)

  if counter == 0
    hostfirmware_json = {:host_firmware_pkg_name => "#{hostfirmware['host_firmware_pkg_name']}",
                         :host_firmware_pkg_description => "#{hostfirmware['host_firmware_pkg_description']}",
                         :org => "#{hostfirmware['org']}", :hardware_model => "#{hostfirmware['hardware_model']}",
                         :hardware_type => "#{hostfirmware['hardware_type']}", :hardware_vendor => "#{hostfirmware['hardware_vendor']}",
                         :firmware_version => "#{hostfirmware['firmware_version']}", :flag => 'initial'}.to_json

  else
    hostfirmware_json = {:host_firmware_pkg_name => "#{hostfirmware['host_firmware_pkg_name']}",
                         :host_firmware_pkg_description => "#{hostfirmware['host_firmware_pkg_description']}",
                         :org => "#{hostfirmware['org']}", :hardware_model => "#{hostfirmware['hardware_model']}",
                         :hardware_type => "#{hostfirmware['hardware_type']}", :hardware_vendor => "#{hostfirmware['hardware_vendor']}",
                         :firmware_version => "#{hostfirmware['firmware_version']}", :flag => 'update'}.to_json
  end

  ucs_provision.set_host_firmware_package(hostfirmware_json)
  log "Created Host Firmware Package #{hostfirmware['host_firmware_pkg_name']} for #{hostfirmware['hardware_model']}"
  #Uncomment to debug
  #log hostfirmware_json

  counter += 1
end

# Uncomment for UCS versions 2.0 versions. Version 2.1 no longer requires use of a Management firmware pack, but adds a CIMC requirement.

#Set Management Firmware - mgmt1.json

# mgmtfirmwares = data_bag("mgmtfirmwares")
# mgmtfirmwares.each do |mgmtfirmware_info|

#   mgmtfirmware = data_bag_item("mgmtfirmwares", mgmtfirmware_info)
#   mgmtfirmware_json = {:mgmt_firmware_pkg_name => "#{mgmtfirmware['mgmt_firmware_pkg_name']}",
#                        :mgmt_firmware_pkg_description => "#{mgmtfirmware['mgmt_firmware_pkg_description']}",
#                        :org => "#{mgmtfirmware['org']}", :hardware_model => "#{mgmtfirmware['hardware_model']}",
#                        :hardware_type => "#{mgmtfirmware['hardware_type']}", :hardware_vendor => "#{mgmtfirmware['hardware_vendor']}",
#                        :firmware_version => "#{mgmtfirmware['firmware_version']}"}.to_json

#   ucs_provision.set_mgmt_firmware_package(mgmtfirmware_json)
#   log "Created Mgmt Firmware Package #{mgmtfirmware['mgmt_firmware_pkg_name']} for #{mgmtfirmware['hardware_model']}"
#   #Uncomment to debug
#   #log mgmtfirmware_json

# end



