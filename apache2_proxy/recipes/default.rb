#
# Cookbook Name:: apache2_proxy
# Recipe:: default
#
require_recipe 'apache2'

template node.apache2_proxy.conf do
  source "httpd_proxy.conf.erb"
  variables :mapping => node.apache2_proxy.mapping
end

file node.apache2_proxy.conf do
  mode "0644"
end

ruby_block "include-proxy-conf" do
  block do
    inc = "Include conf/extra/httpd-proxy.conf"
    conf = File.read(node.apache2.conf)
    unless conf.match(inc)
      open(node.apache2.conf, 'a+') do |f|
        f.puts("\n#{inc}")
      end
    end
  end
end

bash "restart-apache" do
  code "#{node.apache2.apachectl} restart"
end