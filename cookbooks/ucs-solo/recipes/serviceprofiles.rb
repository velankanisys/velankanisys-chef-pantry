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

#Setup Service Profiles and bind them to a template
service_profiles = data_bag("serviceprofiles")
service_profiles.each do |service_profile_info|
  service_profile = data_bag_item("serviceprofiles", service_profile_info)
  service_profiles_json = { :service_profile_names => "#{service_profile['service_profile_names']}",
                            :service_profile_boot_policy => "#{service_profile['service_profile_boot_policy']}",
                            :service_profile_host_fw_policy => "#{service_profile['service_profile_host_fw_policy']}",
                            :service_profile_mgmt_fw_policy => "#{service_profile['service_profile_mgmt_fw_policy']}",
                            :service_profile_uuid_pool => "#{service_profile['service_profile_uuid_pool']}",
                            :service_profile_vnics_a => "#{service_profile['service_profile_vnics_a']}",
                            :service_profile_vnic_a_template => "#{service_profile['service_profile_vnic_a_template']}",
                            :service_profile_vnics_b => "#{service_profile['service_profile_vnics_b']}",
                            :service_profile_vnic_b_template => "#{service_profile['service_profile_vnic_b_template']}",
                            :service_profile_wwnn_pool => "#{service_profile['service_profile_wwnn_pool']}",
                            :service_profile_vhba_a => "#{service_profile['service_profile_vhba_a']}",
                            :service_profile_vhba_a_template => "#{service_profile['service_profile_vhba_a_template']}",
                            :service_profile_vhba_b => "#{service_profile['service_profile_vhba_b']}",
                            :service_profile_vhba_b_template => "#{service_profile['service_profile_vhba_b_template']}",
                            :service_profile_template_to_bind => "#{service_profile['service_profile_template_to_bind']}",
                            :org => "#{service_profile['org']}"}.to_json


  ucs_provision.set_service_profiles(service_profiles_json)
  #uncomment to debug
  #log vhba_templates_json
  log "Created  Service Profiles #{service_profile['service_profile_names']}"

end


