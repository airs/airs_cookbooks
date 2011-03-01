bash "setoff-auto-startup" do
  code "/bin/launchctl unload -w /Library/LaunchDaemons/org.macports.apache2.plist"
  only_if { node.platform == "mac_os_x" }
end

bash "uninstall-apache2" do
  code "port uninstall apache2"
  only_if { node.platform == "mac_os_x" }
end
