bash "setoff-auto-startup" do
  code "/bin/launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  only_if "test -f /Library/LaunchDaemons/org.macports.mysql5.plist"
end

bash "uninstall-mysql" do
  code "port uninstall mysql5-server; port uninstall mysql5"
  only_if { node.platform == "mac_os_x" }
end

bash "remove-install-dir" do
  code "rm -rf #{node.mysql.install_dir}"
end