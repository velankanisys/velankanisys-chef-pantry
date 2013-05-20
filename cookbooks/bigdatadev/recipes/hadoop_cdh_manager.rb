#
# Cookbook Name:: bigdatadev
# Recipe:: [Setup Cloudera Manager: Hadoop]
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
#

# This recipe is for Cloudera Hadoop CDH4 on Ubuntu 12.04.LTS only
# Most of this will refactored in a later version

#include_recipe "java::oracle"

package "curl"


script "Setting up and start Cloudera Manager" do
  interpreter "bash"
  user "root"
  code <<-EOH
  curl -s http://archive.cloudera.com/cm4/ubuntu/precise/amd64/cm/archive.key > key
  apt-key add key
  rm key
  apt-get update
  export DEBIAN_FRONTEND=noninteractive
  apt-get -q -y --force-yes install oracle-j2sdk1.6 cloudera-manager-server-db cloudera-manager-server cloudera-manager-daemons
  service cloudera-scm-server-db initdb
  service cloudera-scm-server-db start
  service cloudera-scm-server start
  EOH
end

