bash "stop-confluence" do
  code "(cd #{node.confluence.install}/bin; ./OS\\ X\\ -\\ Stop\\ Confluence.command)"
  only_if { File.exist?(node.confluence.install) }
end

bash "delete-mysql-confluence-database-and-user" do
  sql =<<EOS
DELETE FROM mysql.user WHERE user = 'confluence';
DROP DATABASE confluence;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  only_if { File.exist?("#{node.mysql.install_dir}/#{node.confluence.mysql_db}") }
end

[node.confluence.home, node.confluence.install].each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end

file "/tmp/confluence.tar.gz" do
  action :delete
end