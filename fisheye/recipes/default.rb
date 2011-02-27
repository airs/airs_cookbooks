#
# Cookbook Name:: fisheye
# Recipe:: default
#

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

bash "start-fisheye" do
  code "(cd #{node.fisheye.install}/bin; ./start.sh)"
end
