%w(nmap wget tree).each do |package_name|
  package package_name do
    action :remove
  end
end