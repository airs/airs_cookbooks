#
# Cookbook Name:: jira
# Recipe:: default
#

require_recipe "mysql"

directory node.jira.home do
  recursive true
  action :create
end

remote_file "jira" do
  path "/tmp/jira.tar.gz"
  source node.jira.download_url
  not_if "test -f /tmp/jira.tar.gz"
end

bash "untar-jira" do
  code "(cd /tmp; tar zxvf jira.tar.gz)"
  not_if { File.exist?("/tmp/#{node.jira.name}") || File.exist?(node.jira.install) }
end

bash "install-jira" do
  code "mv /tmp/#{node.jira.name} #{node.jira.install}"
  not_if { File.exist?(node.jira.install) }
end

template "#{node.jira.properties}" do
  source "jira-application.properties.erb"
end

file "#{node.jira.properties}" do
  mode "0644"
end

template node.jira.server_xml do
  source "server.xml.erb"
  variables :username => node.jira.mysql_user,
            :password => node.jira.mysql_password,
            :db => node.jira.mysql_db
end

file node.jira.server_xml do
  mode "0644"
end

template node.jira.entityengine_xml do
  source "entityengine.xml.erb"
end

file node.jira.entityengine_xml do
  mode "0644"
end

bash "create-mysql-jira-database-and-user" do
  sql =<<EOS
CREATE DATABASE #{node.jira.mysql_db} CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON #{node.jira.mysql_db}.* TO #{node.jira.mysql_user}@'%'
IDENTIFIED BY '#{node.jira.mysql_password}';
FLUSH PRIVILEGES;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  not_if { File.exist?("#{node.mysql.install_dir}/#{node.jira.mysql_db}") }
end

bash "start-jira" do
  code "(cd #{node.jira.install}; ./bin/startup.sh)"
end
