bash "stop-bamboo" do
  code "(cd #{node.bamboo.install}; ./bamboo.sh stop)"
  only_if { File.exist?(node.bamboo.install) }
end

bash "delete-mysql-bamboo-database-and-user" do
  sql =<<EOS
DELETE FROM mysql.user WHERE user = '#{node.bamboo.mysql_user}';
DROP DATABASE #{node.bamboo.mysql_db};
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  only_if { File.exist?("#{node.mysql.install_dir}/#{node.bamboo.mysql_db}") }
end

[node.bamboo.home, node.bamboo.install].each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end

file "/tmp/bamboo.tar.gz" do
  action :delete
end
