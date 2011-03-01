#
# Cookbook Name:: unbound
# Recipe:: remove
#

bash "unload-unbound" do
  code "sudo /bin/launchctl unload -w /Library/LaunchDaemons/org.macports.unbound.plist"
  only_if "test -f /Library/LaunchDaemons/org.macports.unbound.plist"
end

package "unbound" do
  action :remove
end