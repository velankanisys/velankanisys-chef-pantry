#Ubuntu

package 'krb5-admin-server'
package 'krb5-user'
package 'libkrb5-dev'


service 'krb5-admin-server' do
    action :enable
    supports :restart => true, :reload => true
end

service 'krb5-kdc' do
    action :enable
    supports :restart => true, :reload => true
end


template  '/etc/krb5.conf'do
  owner "root"
  group "root"
  mode 00644
  source 'krb5.conf.erb'
  notifies :restart, "service[krb5-kdc]"
end


template  '/etc/krb5kdc/kdc.conf'do
  owner "root"
  group "root"
  mode 00644
  source 'kdc.conf.erb'
  notifies :restart, "service[krb5-kdc]"
end


template  '/etc/krb5kdc/kadm5.acl'do
  owner "root"
  group "root"
  mode 00644
  source 'kadm5.acl.erb'
  notifies :restart, "service[krb5-kdc]"
end

# execute "Create KDC DB" do
#   command "krb5_newrealm"
#   #ignore_failure true
#   #not_if { ::File.exists?("#{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hadoop/dfs/name") }
# end

# cat /dev/vdb >/dev/urandom  &

# cat /proc/sys/kernel/random/entropy_avail

# tcpdump -nettt -i eth0


# service 'krb5-admin-server' do
#     action :start
# end

# service 'krb5-kdc' do
#     action :start
# end
