#
# Author:: Jesse Howarth (<him@jessehowarth.com>)
# Author:: Murali Raju (<murali.raju@appliv.com>) for Hadoop HiveServer specific
#
# Copyright:: Copyright (c) 2012, Opscode, Inc. (<legal@opscode.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mysql::ruby"


# create a mysql database
mysql_database "#{node['hortonworks_hdp']['mysql']['hivedb']}" do
  connection ({:host => "localhost", :username => 'root', :password => node['mysql']['server_root_password']})
  action :create
end


#Create the hivedb_user

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}


# Create a the hive_db user but grant no privileges
mysql_database_user "#{node['hortonworks_hdp']['mysql']['hivedb_user_name']}" do
  connection mysql_connection_info
  password "#{node['mysql']['hivedb_user_password']}"
  action :create
end

# Grant privileges to hive_db

mysql_database_user "#{node['hortonworks_hdp']['mysql']['hivedb_user_name']}" do
  connection mysql_connection_info
  password "#{node['hortonworks_hdp']['mysql']['hivedb_user_password']}"
  database_name "#{node['hortonworks_hdp']['mysql']['hivedb']}"
  privileges [:all]
  action :grant
end
