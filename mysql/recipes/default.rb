#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2011, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
  
package "mysql5-server" do
  action :install
end

template node.mysql.my_cnf do
  source "my.cnf.erb"
  variables :socket => node.mysql.socket,
            :my_cnf => node.mysql.my_cnf,
            :install_dir => node.mysql.install_dir
end

file node.mysql.my_cnf do
  owner "root"
  group "admin"
  mode "0644"
end

bash "setup-mysql" do
  code "sudo -u mysql /opt/local/lib/mysql5/bin/mysql_install_db"
  only_if { node.platform == "mac_os_x" }
end

bash "startup-mysql" do
  code "#{node.mysql.service} start"
end

bash "set-root-password" do
  password = node.mysql.root_password
  sql = <<EOS
SET PASSWORD FOR root@'#{node.hostname}.local'=password('#{password}');
SET PASSWORD FOR root@'127.0.0.1'=password('#{password}');
EOS
  code "#{node.mysql.mysql_admin} -u root password '#{password}'"
  code %|#{node.mysql.mysql} -u root -p"#{password}" -e"#{sql}"|
end

bash "delete-anonymous-user" do
  sql = "DELETE FROM mysql.user WHERE user = '';"
  code %|#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}"|
end

bash "setup-auto-startup" do
  code "/bin/launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  only_if { node.platform == "mac_os_x" }
end
