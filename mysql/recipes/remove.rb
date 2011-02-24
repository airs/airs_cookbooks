bash "stop-mysql-server" do
  code "/bin/launchctl unload -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  only_if "test -f /Library/LaunchDaemons/org.macports.mysql5.plist"
end

%w(mysql5-server mysql5).each do |package_name|
  package package_name do
    action :remove
  end
end
