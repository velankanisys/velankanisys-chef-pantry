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

%w'oozie
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