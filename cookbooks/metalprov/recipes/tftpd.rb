#
# Cookbook Name:: tftpd
# Recipe:: tftpd [Setup tftpd for Razors]
#
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

include_recipe "metalprov::dhcpd"


dist = node[:metalprov][:ipxe][:dist] 
path = node[:metalprov][:ipxe][:path]
dist_usb = node[:metalprov][:ipxe][:dist_usb] 
path_usb = node[:metalprov][:ipxe][:path_usb]
dist_misc = node[:metalprov][:ipxe][:dist_misc] 
path_misc = node[:metalprov][:ipxe][:path_misc]


remote_file "/tmp/#{dist}.iso" do
  source "#{path}"
  not_if { File.exists?("/tmp/#{dist}.iso") }
end

remote_file "/tmp/#{dist_usb}.lkrn" do
  source "#{path_usb}"
  not_if { File.exists?("/tmp/#{dist_usb}.lkrn") }
end

remote_file "/tmp/#{dist_misc}.kpxe" do
  source "#{path_misc}"
  not_if { File.exists?("/tmp/#{dist_misc}.kpxe") }
end

script "Copy files to tftp root" do
  interpreter "bash"
  user "root"
  code <<-EOH
  mkdir /var/lib/tftpboot/pxelinux.cfg
  cp /tmp/#{dist}.iso /var/lib/tftpboot/
  cp /tmp/#{dist_usb}.lkrn /var/lib/tftpboot/
  cp /tmp/#{dist_misc}.kpxe /var/lib/tftpboot/
  cp /usr/lib/syslinux/pxelinux.0 /var/lib/tftpboot/
  cp /usr/lib/syslinux/menu.c32 /var/lib/tftpboot/
  chmod -R 655 /var/lib/tftpboot
  EOH
end


# template "/var/lib/tftpboot/preseed.ubuntu.cfg" do
#   source "preseed.ubuntu.cfg.erb"
#   mode 0644
# end
# 
template "/var/lib/tftpboot/pxelinux.cfg/default" do
  source "pxelinux.default.erb"
  mode 0644
end

