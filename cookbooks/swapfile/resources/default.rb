actions :create, :delete
default_action :create

def initialize(*args)
  super
  @action = :create
end

attribute :name, :kind_of => String, :name_attribute => true
attribute :swapfile_location, :kind_of => String
attribute :swapsize, :kind_of => Integer
