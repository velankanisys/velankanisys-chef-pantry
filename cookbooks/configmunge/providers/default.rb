action :munge do
  filters = new_resource.filter.class == Regexp ? [ new_resource.filter ] : new_resource.filter
  rebuilt_config = Array.new
  ::File.open(new_resource.config_file, "r") do | f |
    while line = f.gets
      if filters.any? { | filter | line =~ filter }
        next
      else
        rebuilt_config << line
      end
    end
  end
  rebuilt_config.push(*new_resource.appended_configs)
  ::File.open(new_resource.config_file, "w") do | f |
    rebuilt_config.each do | line |
      f.write(line)
    end
  end
end
