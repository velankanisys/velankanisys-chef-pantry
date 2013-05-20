#
# Cookbook Name:: pxe
# Recipe:: tftpd [Setup SuSE install via tftpd]
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


dist = node[:pxe][:linux][:release][:dist]
path = node[:pxe][:linux][:release][:path]

remote_file "/tmp/#{dist}-DVD-x86_64-GM-DVD1.iso" do
  source "#{path}"
  not_if { File.exists?("/tmp/#{dist}-DVD-x86_64-GM-DVD1.iso") }
end


script "copy install files from iso" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir /var/www/suse/
  mkdir /var/lib/tftpboot/pxelinux.cfg
  mount -o loop /tmp/#{dist}-DVD-x86_64-GM-DVD1.iso /mnt
  cp -a /mnt/* /var/www/suse/
  cp /mnt/boot/x86_64/loader/linux /var/lib/tftpboot/linux64
  cp /mnt/boot/x86_64/loader/initrd /var/lib/tftpboot/initrd64
  cp /usr/lib/syslinux/pxelinux.0 /var/lib/tftpboot/pxelinux.0
  EOH
end


service "networking" do
  supports :restart => true
end

service "isc-dhcp-server"  do
  supports :restart => true
end

service "tftpd-hpa"  do
  supports :restart => true
end


state = @ucs_manager.discover_state
state.xpath("configResolveClasses/outConfigs/macpoolPooled").each do |macpool|
  if "#{macpool.attributes["assigned"]}" == 'yes' and "#{macpool.attributes["assignedToDn"].to_s.scan(/ether-vNIC-(\w+)/)}" == '[["A"]]'
    mac = "#{macpool.attributes["id"]}"
    template "/var/lib/tftpboot/pxelinux.cfg/01-#{mac}" do # It looks for 01-#{mac} for some reason.
        source "suseboot.default.erb"
        mode 0644
        variables({
          :mac => mac,
          :release => node[:pxe][:os][:release]
        })
        notifies :restart, resources(:service => "tftpd-hpa"), :delayed
    end
  end
end

template "/var/www/suse/autoinst.xml" do
  source "autoinst.xml.erb"
  mode 0644
end

template "/var/lib/tftpboot/pxelinux.cfg/default" do
  source "suseboot.default.erb"
  mode 0644
end
