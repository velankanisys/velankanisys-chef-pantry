define :k5login,
	:principals => nil,
	:user => "root" do

  princs = (params[:name] || params[:principals]).map{ |p| (p.include? "@") ? p : p + "@" + node["kerberos"]["default_realm"] }

  file "/#{params[:user]}/.k5login" do
    action :delete if princs.empty?
    mode 0600
    owner params[:user]
    group params[:user]
    content princs.join("\n") + "\n"
  end
  
end
