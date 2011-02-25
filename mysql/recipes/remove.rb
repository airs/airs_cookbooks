bash "setoff-auto-startup" do
  code "/bin/launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  only_if "test -f /Library/LaunchDaemons/org.macports.mysql5.plist"
end

bash "uninstall-mysql" do
  code "port uninstall mysql5-server; port uninstall mysql5"
  only_if { node.platform == "mac_os_x" }
end

directory node.mysql.install_dir do
  recursive true
  action :delete
end

file node.crowd.home do
  action :delete
end
