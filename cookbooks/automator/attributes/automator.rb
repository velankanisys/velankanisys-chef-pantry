#Current supported platform - Debian Squeeze
#Orchestrator
default[:automator][:orchestrator][:dist] = "rundeck-1.4.4"
default[:automator][:orchestrator][:path] = "https://s3.amazonaws.com/velankanidownloads/rundeck-1.4.4.deb"
default[:automator][:orchestrator][:cookbooks_path] = "https://github.com/velankanisys/chef-cookbooks/archive/master.tar.gz"
default[:automator][:orchestrator][:cookbooks] = "velankanisys-chef-cookbooks"
default[:automator][:orchestrator][:data_bags] = "/etc/chef/chef-cookbooks-master/ucs-solo/data_bags"
default[:automator][:orchestrator][:project] = "ucs"
