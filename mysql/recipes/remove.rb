bash "stop-mysql-server" do
  code "/bin/launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  only_if { node.platform == "mac_os_x" }
end

bash "remove-my.cnf" do
  code "rm -f #{node.mysql.my_cnf}"
end

package "mysql5-server" do
  action :remove
end

package "mysql5" do
  action :remove
end
