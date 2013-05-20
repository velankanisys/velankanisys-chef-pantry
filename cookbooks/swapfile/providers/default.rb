action :create do
  execute "dd swap file" do
    command "\
dd if=/dev/zero of=#{new_resource.swapfile_location} bs=1024 count=#{new_resource.swapsize} && \
mkswap #{new_resource.swapfile_location} && \
swapon #{new_resource.swapfile_location}"
    not_if do
      ::File.exists?(new_resource.swapfile_location) || Integer(node[:memory][:swap][:total].sub("kB", '')) >= new_resource.swapsize
    end
  end
  configmunge "create swapfile in fstab" do
    config_file "/etc/fstab"
    filter /^#{new_resource.swapfile_location}/
    appended_configs ["#{new_resource.swapfile_location} none swap sw 0 0\n"]
  end
end

action :delete do
  execute "remove swapfile" do
    command "swapoff #{new_resource.swapfile_location} && \
rm -f #{new_resource.swapfile_location}"
  end
  configmunge "remove swapfile from fstab" do
    config_file "/etc/fstab"
    filter /^#{new_resource.swapfile_location}/
    appended_configs ["\n"]
  end
end
