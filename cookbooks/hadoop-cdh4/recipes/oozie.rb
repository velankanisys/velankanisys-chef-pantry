#
# Cookbook Name:: hadoop-cdh4
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

oozie_lib_path = node[:cloudera_cdh][:oozie][:lib]
mysql_connector_java = node[:cloudera_cdh][:mysql][:jdbc_connector]

%w'unzip
oozie
oozie-client'.each do | pack |
  package pack do
    action :install
    options "--force-yes"
  end
end


# create a mysql database
mysql_database "#{node['cloudera_cdh']['mysql']['ooziedb']}" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end


#Create the ooziedb_user

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}


# Create a the oozie_db user but grant no privileges
mysql_database_user "#{node['cloudera_cdh']['mysql']['ooziedb_user_name']}" do
  connection mysql_connection_info
  password "#{node['mysql']['ooziedb_user_password']}"
  action :create
end

# Grant privileges to oozie_db
mysql_database_user "#{node['cloudera_cdh']['mysql']['ooziedb_user_name']}" do
  connection mysql_connection_info
  password "#{node['cloudera_cdh']['mysql']['ooziedb_user_password']}"
  database_name "#{node['cloudera_cdh']['mysql']['ooziedb']}"
  privileges [:all]
  action :grant
end

remote_file "#{oozie_lib_path}/mysql-connector-java-5.1.9.jar" do
  source "#{mysql_connector_java}"
  not_if { File.exists?("#{oozie_lib_path}/mysql-connector-java-5.1.9.jar") }
end

remote_file "/tmp/ext-2.2.zip" do
  source "http://archive.cloudera.com/gplextras/misc/ext-2.2.zip"
  not_if { File.exists?("/tmp/ext-2.2.zip") }
end

script "Setting up environment" do
  interpreter "bash"
  user "root"
  code <<-EOH
  chmod -R 777 /var/lib/oozie
  chown -R oozie:oozie /var/lib/oozie
  sudo -u hdfs hadoop fs -mkdir /user/oozie
  sudo -u hdfs hadoop fs -chown oozie:oozie /user/oozie
  cp /tmp/ext-2.2.zip  /var/lib/oozie
  cd /var/lib/oozie
  unzip ext-2.2.zip
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
#   	| grep #{node['cloudera_cdh']['mysql']['ooziedb']}")
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

service "oozie" do
  action [ :enable, :restart ]
end