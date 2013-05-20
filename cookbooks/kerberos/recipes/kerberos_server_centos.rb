#Centos

package 'krb5-server'
package 'krb5-workstation'
package 'krb5-libs'
package 'krb5-devel'


service 'krb5kdc' do
    action :enable
    supports :restart => true, :reload => true
end


template  '/etc/krb5.conf'do
  owner "root"
  group "root"
  mode 00644
  source 'krb5.conf.erb'
  #notifies :restart, "service[krb5kdc]"
end


template  '/var/kerberos/krb5kdc/kdc.conf'do
  owner "root"
  group "root"
  mode 00644
  source 'kdc.conf.centos.erb'
  #notifies :restart, "service[krb5kdc]"
end


template  '/var/kerberos/krb5kdc/kadm5.acl'do
  owner "root"
  group "root"
  mode 00644
  source 'kadm5.acl.erb'
  #notifies :restart, "service[krb5kdc]"
end

# execute "Create KDC DB" do
#   command "kdb5_util create"
#   #ignore_failure true
#   #not_if { ::File.exists?("#{node[:hortonworks_hdp][:namenode][:dfs_name_dir_root]}/var/lib/hadoop/cache/hadoop/dfs/name") }
# end

# cat /dev/vdb >/dev/urandom  &

# cat /proc/sys/kernel/random/entropy_avail

# tcpdump -nettt -i eth0


# kadmin.local
# kadmin: add_principal -randkey afs/example.com
# kadmin: add_principal admin
# kadmin: add_principal user
# kadmin: quit

# service 'krb5kdc' do
#     action :start
# end

