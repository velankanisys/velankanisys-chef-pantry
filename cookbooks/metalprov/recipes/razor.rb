#
# Cookbook Name:: metalprov
# Recipe:: [Setup Razor]
#
# Copyright 2012, Velankani Information Systems, Inc eng@velankani.net
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# cookbooksributed under the License is cookbooksributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "metalprov::tftpd"

gem_package "autotest"
gem_package "base62"
gem_package "bson"
gem_package "bson_ext"
gem_package "colored"
gem_package "daemons"
gem_package "json"
gem_package "logger"
gem_package "macaddr"
gem_package "mocha"
gem_package "mongo"
gem_package "net-ssh"
gem_package "require_all"
gem_package "syntax"
gem_package "uuid"

dist = node[:metalprov][:razor][:dist]
path = node[:metalprov][:razor][:path]
mk = node[:metalprov][:razor][:mk]
mk_path = node[:metalprov][:razor][:mk_path]

remote_file "/opt/#{dist}" do
  source "#{path}"
  not_if { File.exists?("/opt/#{dist}") }
end

remote_file "/tmp/#{mk}.iso" do
  source "#{mk_path}"
  not_if { File.exists?("/tmp/#{mk}.iso") }
end

script "Installing Razor" do
  interpreter "bash"
  user "root"
  code <<-EOH
  cd /opt
  npm install express@2.5.11
  npm install mime
  unzip #{dist}
  /opt/Razor-master/bin/razor_daemon.rb start
  /opt/Razor-master/bin/razor config ipxe > /var/lib/tftpboot/razor.ipxe 
  chmod -R 655 /var/lib/tftpboot
  echo "export PATH=/opt/Razor-master/bin:$PATH" >> ~/.bashrc
  echo "/opt/Razor-master/bin/razor_daemon.rb start" > /etc/rc.local
  sleep 5s
  EOH
end

script "Adding Micro Kernel Image" do
  interpreter "bash"
  user "root"
  code <<-EOH
  /opt/Razor-master/bin/razor -v -d image add -t mk -p /tmp/#{mk}.iso
  EOH
end

service "networking" do
  supports :restart => true
  action :restart
end

service "tftpd-hpa"  do
  supports :restart => true
  action :restart
end

service "isc-dhcp-server"  do
  supports :restart => true
  action :restart
end

#razor -v -d image add -t mk -p /tmp/rz_mk_dev-image.0.9.3.0.iso
#razor -v -d image add -t os -p /tmp/ubuntu-12.04.1-server-amd64.iso -n ubuntu_precise -v 12.04
#razor model add -t ubuntu_precise -l install_precise -i 2WdVsigEAlEmdHmqSY4ew7
#razor broker add -p chef -n Chef_1 -d Development
#razor policy add -p linux_deploy -l precise -m 2grOi1LEiSIXZWdjk2FNtC -b 2MQK3Mt9Ao80npmYltKSZ8 -t vmware_vm,cpus_1,memsize_512MiB,nics_1,IntelCorporation -e true
#razor policy update 5QaDlx486C0siF8RTsRcpC -l precise -m 2GEEDmZGgy1zIKgM2b94UA -b 6oqpqUGGsTczJjBiCIPytC 





