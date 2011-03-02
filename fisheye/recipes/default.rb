#
# Cookbook Name:: fisheye
# Recipe:: default
#
require 'rexml/document'
require_recipe 'mysql'

remote_file "fisheye" do
  path "/tmp/fisheye.zip"
  source node.fisheye.download_url
  not_if "test -f /tmp/fisheye.zip"
end

bash "unzip-fisheye" do
  code "(cd /tmp; unzip fisheye.zip)"
  not_if { File.exist?("/tmp/#{node.fisheye.name}") || File.exist?(node.fisheye.install) }
end

bash "install-fisheye" do
  code "mv /tmp/#{node.fisheye.name} #{node.fisheye.install}"
  not_if { File.exist?(node.fisheye.install) }
end

template "#{node.fisheye.fisheyectl}" do
  source "fisheyectl.sh.erb"
end

file "#{node.fisheye.fisheyectl}" do
  mode "0755"
end

ruby_block "set-server-context" do
  block do
    if File.exist?(node.fisheye.config)
      doc = REXML::Document.new(open(node.fisheye.config).read)
      if doc.elements['/config/web-server'].attributes["context"] != "fisheye"
        doc.elements['/config/web-server'].attributes["context"] = "fisheye"
        File.open(node.fisheye.config, 'w') do |f|
          f.puts(doc.to_s)
        end
      end
    end
  end
end

bash "create-mysql-fisheye-database-and-user" do
  sql =<<EOS
CREATE DATABASE #{node.fisheye.mysql_db} CHARACTER SET utf8;
GRANT ALL PRIVILEGES ON #{node.fisheye.mysql_db}.* TO #{node.fisheye.mysql_user}@'%'
IDENTIFIED BY '#{node.fisheye.mysql_password}';
FLUSH PRIVILEGES;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  not_if { File.exist?("#{node.mysql.install_dir}/#{node.fisheye.mysql_db}") }
end

bash "start-fisheye" do
  code "(cd #{node.fisheye.install}/bin; ./start.sh)"
end
