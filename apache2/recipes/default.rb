#
# Cookbook Name:: apache2
# Recipe:: default
#

package "apache2" do
  action :install
end

bash "setup-auto-startup" do
  code "/bin/launchctl load -w /Library/LaunchDaemons/org.macports.apache2.plist"
  only_if { node.platform == "mac_os_x" }
end
