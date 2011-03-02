bash "stop-fisheye" do
  code "(cd #{node.fisheye.install}/bin; ./stop.sh)"
  only_if { File.exist?(node.fisheye.install) }
end

bash "delete-mysql-fisheye-database-and-user" do
  sql =<<EOS
DELETE FROM mysql.user WHERE user = '#{node.fisheye.mysql_user}';
DROP DATABASE #{node.fisheye.mysql_db};
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  only_if { File.exist?("#{node.mysql.install_dir}/#{node.fisheye.mysql_db}") }
end

directory node.fisheye.install do
  recursive true
  action :delete
end

file "/tmp/fisheye.tar.gz" do
  action :delete
end