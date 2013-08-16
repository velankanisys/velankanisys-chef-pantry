#
# Cookbook Name:: hadoop-hdp
# Recipe:: oozie
#
# Author: Murali Raju <murali.raju@appliv.com>
#
# Copyright 2013, Velankani Information Systems, Inc eng@velankani.net
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

include_recipe "database::mysql"

oozie_lib_path = node[:hortonworks_hdp][:oozie][:lib]
mysql_connector_java = node[:hortonworks_hdp][:mysql][:jdbc_connector]

%w'unzip
oozie
oozie-client
extjs'.each do | pack |
  package pack do
    action :install
    #options "--force-yes"
  end
end


# create a mysql database
mysql_database "#{node['hortonworks_hdp']['mysql']['ooziedb']}" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end


#Create the ooziedb_user

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}


# Create a the oozie_db user but grant no privileges
mysql_database_user "#{node['hortonworks_hdp']['mysql']['ooziedb_user_name']}" do
  connection mysql_connection_info
  password "#{node['mysql']['ooziedb_user_password']}"
  action :create
end

# Grant privileges to oozie_db
mysql_database_user "#{node['hortonworks_hdp']['mysql']['ooziedb_user_name']}" do
  connection mysql_connection_info
  password "#{node['hortonworks_hdp']['mysql']['ooziedb_user_password']}"
  database_name "#{node['hortonworks_hdp']['mysql']['ooziedb']}"
  privileges [:all]
  action :grant
end

remote_file "#{oozie_lib_path}/mysql-connector-java-5.1.9.jar" do
  source "#{mysql_connector_java}"
  not_if { File.exists?("#{oozie_lib_path}/mysql-connector-java-5.1.9.jar") }
end


script "Setting up environment" do
  interpreter "bash"
  user "root"
  code <<-EOH
  chmod -R 777 /var/lib/oozie
  chown -R oozie:oozie /var/lib/oozie
  sudo -u hdfs hadoop fs -mkdir /user/oozie
  sudo -u hdfs hadoop fs -chown oozie:oozie /user/oozie
  /usr/lib/oozie/bin/oozie-setup.sh -hadoop 0.20.200 /usr/lib/hadoop -extjs /usr/share/HDP-oozie/ext-2.2.zip
  /usr/lib/oozie/bin/oozie-setup.sh -hadoop 2.x /usr/lib/hadoop -extjs /usr/share/HDP-oozie/ext-2.2.zip -jars /usr/lib/hadoop/lib/hadoop-lzo-0.5.0.jar 
  EOH
  not_if { "hadoop fs -ls /user | egrep oozie" }
end

script "Setting up Oozie sharedlib" do
  interpreter "bash"
  user "root"
  code <<-EOH
  cd /tmp
  tar -xzvf /usr/lib/oozie/oozie-sharelib.tar.gz 
  sudo -u oozie hadoop fs -put share /user/oozie/share
  EOH
  not_if { "hadoop fs -ls /user/oozie | egrep share" }
end


#TODO
# script "Create DB schema" do
#   interpreter "bash"
#   user "root"
#   code <<-EOH
#   sudo -u oozie /usr/lib/oozie/bin/ooziedb.sh create -run
#   EOH
#   not_if("/usr/bin/mysql -uroot -p #{node['mysql']['server_root_password']} -e'show databases' 
#   	| grep #{node['hortonworks_hdp']['mysql']['ooziedb']}")
# end

script "Creating and copying workflows" do
  interpreter "bash"
  user "root"
  code <<-EOH
  cd /root
  mkdir -p oozie-workflows/lib
  cp /usr/lib/hive/lib/hive-serdes-1.0-SNAPSHOT.jar oozie-workflows/lib
  cp /var/lib/oozie//var/lib/oozie/mysql-connector-*.jar oozie-workflows/lib
  cp /etc/hive/conf/hive-site.xml oozie-workflows
  chown root:root oozie-workflows/hive-site.xml
  hadoop fs -put oozie-workflows /user/root/oozie-workflows
  EOH
  not_if { "hadoop fs -ls /user/root | egrep oozie-workflows" }
end

template "start-oozie.sh" do
  path "/usr/local/bin/start-oozie.sh"
  source "start-oozie.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "oozie-site.xml" do
  path "/etc/oozie/conf/oozie-site.xml"
  source "oozie-site.xml.erb"
  owner "root"
  group "root"
  mode "0755"
end

template "oozie-server" do
  path "/etc/init/oozie-server.conf"
  source "oozie-init.conf.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :enable, "service[oozie-server]"
  notifies :start, "service[oozie-server]"
end

service "oozie-server" do
    provider Chef::Provider::Service::Upstart
    supports :status => true, :restart => true
    action [:enable, :start]
end

 