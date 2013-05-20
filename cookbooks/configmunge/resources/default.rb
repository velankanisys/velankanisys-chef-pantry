actions :munge
default_action :munge

def initialize(*args)
  super
  @action = :munge
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :config_file, :kind_of => [ String, Array ]
attribute :filter, :kind_of => Regexp
attribute :appended_configs, :kind_of => Array
