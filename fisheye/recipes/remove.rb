bash "stop-fisheye" do
  code "(cd #{node.fisheye.install}/bin; ./stop.sh)"
  only_if { File.exist?(node.fisheye.install) }
end

directory node.fisheye.install do
  recursive true
  action :delete
end

file "/tmp/fisheye.tar.gz" do
  action :delete
end