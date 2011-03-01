#
# Cookbook Name:: bamboo
# Recipe:: default
#
require_recipe "mysql"

directory node.bamboo.home do
  recursive true
  action :create
end

remote_file "bamboo" do
  path "/tmp/bamboo.tgz"
  source node.bamboo.download_url
  not_if "test -f /tmp/bamboo.tgz"
end

bash "untar-bamboo" do
  code "(cd /tmp; tar zxvf bamboo.tgz)"
  not_if { File.exist?("/tmp/#{node.bamboo.name}") || File.exist?(node.bamboo.install) }
end

bash "install-bamboo" do
  code "mv /tmp/#{node.bamboo.name} #{node.bamboo.install}"
  not_if { File.exist?(node.bamboo.install) }
end

template "#{node.bamboo.properties}" do
  source "bamboo-init.properties.erb"
end

file "#{node.bamboo.properties}" do
  mode "0644"
end

bash "create-mysql-bamboo-database-and-user" do
  sql =<<EOS
CREATE DATABASE #{node.bamboo.mysql_db} CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON #{node.bamboo.mysql_db}.* TO #{node.bamboo.mysql_user}@'%'
IDENTIFIED BY '#{node.bamboo.mysql_password}';
FLUSH PRIVILEGES;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  not_if { File.exist?("#{node.mysql.install_dir}/#{node.bamboo.mysql_db}") }
end

bash "start-bamboo" do
  code "(cd #{node.bamboo.install}; ./bamboo.sh start)"
  not_if "test -f #{node.bamboo.install}/bamboo.pid"
end
