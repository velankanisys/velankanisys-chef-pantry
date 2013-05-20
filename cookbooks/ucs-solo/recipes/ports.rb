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

#include_recipe 'ucs::firmware'

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

#Set Server Ports

serverports = data_bag("serverports")

serverports.each do |serverport_info|
  serverport = data_bag_item("serverports", serverport_info)

  #Get the range port of server ports to be turned up
  start_port = "#{serverport['port_range_start']}".to_i
  end_port = "#{serverport['port_range_end']}".to_i
  #ports = end_port + 1

  (start_port..end_port).each do |port|
    serverport_json = {:switch => "#{serverport['switch']}", :port => "#{port}",
                       :slot => "#{serverport['slot']}".to_i}.to_json
    ucs_provision.set_server_port(serverport_json)
    log "Created port #{port} on Switch #{serverport['switch']} and Slot #{serverport['slot']}"
    #uncomment to debug
    #log serverport_json
    port += 1
  end

end

#Set Port Channels - It is important to create port channels before creating the uplink ports

portchannels = data_bag("portchannels")
portchannels.each do |portchannel_info|
  portchannel = data_bag_item("portchannels", portchannel_info)
  portchannel_json = {:switch => "#{portchannel['switch']}", :port_ids => "#{portchannel['port_ids']}",
                      :slot => "#{portchannel['slot']}".to_i, :name => "#{portchannel['name']}",
                      :port_channel_id => "#{portchannel['port_channel_id']}"}.to_json
  ucs_provision.set_port_channel(portchannel_json)
  #uncomment to debug
  log "Created Port Channel #{portchannel['name']} ID #{portchannel['port_channel_id']} on Switch #{portchannel['switch']} and Slot #{portchannel['slot']}"
  #log portchannel_json
end


#Set Network Uplink Ports

uplinkports = data_bag("uplinkports")

uplinkports.each do |uplinkport_info|
  uplinkport = data_bag_item("uplinkports", uplinkport_info)

  #Get the range port of server ports to be turned up
  start_port = "#{uplinkport['port_range_start']}".to_i
  end_port = "#{uplinkport['port_range_end']}".to_i
  #ports = end_port + 1

  (start_port..end_port).each do |port|
    uplinkport_json = {:switch => "#{uplinkport['switch']}", :port => "#{port}",
                       :slot => "#{uplinkport['slot']}".to_i}.to_json
    ucs_provision.set_network_uplink_port(uplinkport_json)
    #uncomment to debug
    log "Created Uplink Port #{port} on Switch #{uplinkport['switch']} and Slot #{uplinkport['slot']}"
    #log uplinkport_json
    port += 1
  end

end


#Set FC Uplink Ports

fcuplinkports = data_bag("fcuplinkports")

fcuplinkports.each do |fcuplinkport_info|
  fcuplinkport = data_bag_item("fcuplinkports", fcuplinkport_info)

  #Get the range port of server ports to be turned up
  start_port = "#{fcuplinkport['port_range_start']}".to_i
  end_port = "#{fcuplinkport['port_range_end']}".to_i
  #ports = end_port + 1

  (start_port..end_port).each do |port|
    fcuplinkport_json = {:switch => "#{fcuplinkport['switch']}", :port => "#{port}",
                         :slot => "#{fcuplinkport['slot']}".to_i}.to_json
    ucs_provision.set_fc_uplink_port(fcuplinkport_json)
    #uncomment to debug
    log "Created FC Uplink Port #{port} on Switch #{fcuplinkport['switch']} and Slot #{fcuplinkport['slot']}"
    #log fcuplinkport_json
    port += 1
  end

end

