template "/etc/hosts" do
  source "hosts.erb"
  mode 0644
end

template "/etc/apt/sources.list" do
  source "sources.list.erb"
  mode 0644
end

template "/etc/apt/sources.list.d/cloudera-cm4.list" do
  source "cloudera-cm4.list.erb"
  mode 0644
end

