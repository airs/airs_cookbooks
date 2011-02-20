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

my_cnf = { :mac_os_x => "/opt/local/etc/mysql5/my.cnf" }
if node.platform == "mac_os_x" and not File.exist?(my_cnf[:mac_os_x])

  Chef::Log.info("Install MySQL on #{node.platform}")
  
  package "mysql5-server" do
    action :install
  end
  
  template my_cnf[:mac_os_x] do
    source "mac_os_x-my.cnf.erb"
  end
  
  file my_cnf[:mac_os_x] do
    owner "root"
    group "admin"
    mode "0644"
  end
  
  execute "setup-mysql" do
    command "sudo -u mysql /opt/local/lib/mysql5/bin/mysql_install_db"
  end
  
  execute "set-root-password" do
    only_if { node.attribute?("mysql") and node.mysql.attribute?("root_password") }
    command "/opt/local/share/mysql5/mysql/mysql.server start"
    password = node.mysql.root_password
    sql = <<EOS
SET PASSWORD FOR root@'#{node.hostname}.local'=password('#{password}');
SET PASSWORD FOR root@'127.0.0.1'=password('#{password}');
DELETE FROM mysql.user WHERE user = '';
EOS
    command "/opt/local/lib/mysql5/bin/mysqladmin -u root password '#{password}'"
    command %|/opt/local/bin/mysql5 -u root -p"#{password}" -e"#{sql}"|
    command "/opt/local/share/mysql5/mysql/mysql.server stop"
  end
  
  execute "setup-auto-startup" do
    command "/bin/launchctl load -w /Library/LaunchDaemons/org.macports.mysql5.plist"
  end
end
