bash "stop-mysql-server" do
  code "/bin/launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  only_if "test -f /Library/LaunchDaemons/org.macports.mysql5.plist"
end

package "mysql5-server" do
  action :remove
end

package "mysql5" do
  action :remove
end
