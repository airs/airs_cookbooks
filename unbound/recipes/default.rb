#
# Cookbook Name:: unbound
# Recipe:: default
#

package "unbound" do
  action :install
end

template node.unbound.conf do
  source "unbound.conf.erb"
  variables :interface => node.unbound.interface,
            :access_control => node.unbound.access_control,
            :local_data_list => node.unbound.local_data_list
  not_if "test -f #{node.unbound.conf}"
end

file node.unbound.conf do
  mode "0644"
end

bash "load-unbound" do
  code "sudo /bin/launchctl load -w /Library/LaunchDaemons/org.macports.unbound.plist"
end