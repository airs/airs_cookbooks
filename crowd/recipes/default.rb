#
# Cookbook Name:: crowd
# Recipe:: default
#
require_recipe "mysql"

directory node.crowd.home do
  recursive true
  action :create
end

remote_file "crowd" do
  path "/tmp/crowd.tar.gz"
  source node.crowd.download_url
  not_if "test -f /tmp/crowd.tar.gz"
end

bash "untar-crowd" do
  code "(cd /tmp; tar zxvf crowd.tar.gz)"
  not_if { File.exist?("/tmp/#{node.crowd.name}") || File.exist?(node.crowd.install) }
end

bash "install-crowd" do
  code "mv /tmp/#{node.crowd.name} #{node.crowd.install}"
  not_if { File.exist?(node.crowd.install) }
end

template "#{node.crowd.properties}" do
  source "crowd-init.properties.erb"
end

file "#{node.crowd.properties}" do
  mode "0644"
end

bash "create-mysql-crowd-database-and-user" do
  sql =<<EOS
CREATE DATABASE #{node.crowd.mysql_db} CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON #{node.crowd.mysql_db}.* TO #{node.crowd.mysql_user}@'%'
IDENTIFIED BY '#{node.crowd.mysql_password}';
FLUSH PRIVILEGES;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  not_if { File.exist?("#{node.mysql.install_dir}/#{node.crowd.mysql_db}") }
end

remote_file "mysql-jdbc-driver" do
  path "/tmp/mysql_connector.tar.gz"
  source node.mysql.driver_url
  not_if "test -f /tmp/mysql_connector.tar.gz"
end

bash "untar-mysql-jdbc-driver" do
  code "(cd /tmp; tar zxvf mysql_connector.tar.gz)"
  not_if "test -f /tmp/#{node.mysql.driver_name}/#{node.mysql.driver_name}-bin.jar"
end

bash "install-mysql-jdbc-driver" do
  code "mv /tmp/#{node.mysql.driver_name}/#{node.mysql.driver_name}-bin.jar #{node.crowd.install}/apache-tomcat/lib/"
  not_if "test -f #{node.crowd.install}/apache-tomcat/lib/#{node.mysql.driver_name}-bin.jar"
end

bash "start-crowd" do
  code "(cd #{node.crowd.install}; ./start_crowd.sh)"
end