#
# Cookbook Name:: confluence
# Recipe:: default
#

require_recipe "mysql"

directory node.confluence.home do
  recursive true
  action :create
end

remote_file "confluence" do
  path "/tmp/confluence.tar.gz"
  source node.confluence.download_url
  not_if "test -f /tmp/confluence.tar.gz"
end

bash "untar-confluence" do
  code "(cd /tmp; tar zxvf confluence.tar.gz)"
  not_if { File.exist?("/tmp/#{node.confluence.name}") || File.exist?(node.confluence.install) }
end

bash "install-confluence" do
  code "mv /tmp/#{node.confluence.name} #{node.confluence.install}"
  not_if { File.exist?(node.confluence.install) }
end

template "#{node.confluence.setenv}" do
  source "setenv.sh.erb"
end

file "#{node.confluence.setenv}" do
  mode "0644"
end

template "#{node.confluence.properties}" do
  source "confluence-init.properties.erb"
end

file "#{node.confluence.properties}" do
  mode "0644"
end

template "#{node.confluence.server_xml}" do
  source "server.xml.erb"
end

file "#{node.confluence.server_xml}" do
  mode "0644"
end

bash "create-mysql-confluence-database-and-user" do
  sql =<<EOS
CREATE DATABASE #{node.confluence.mysql_db} CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON #{node.confluence.mysql_db}.* TO #{node.confluence.mysql_user}@'%'
IDENTIFIED BY '#{node.confluence.mysql_password}';
FLUSH PRIVILEGES;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  not_if { File.exist?("#{node.mysql.install_dir}/#{node.confluence.mysql_db}") }
end

bash "start-confluence" do
  code "(cd #{node.confluence.install}/bin; ./OS\\ X\\ -\\ Run\\ Confluence\\ In\\ Background.command)"
end
