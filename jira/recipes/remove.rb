bash "stop-jira" do
  code "(cd #{node.jira.install}; ./bin/shutdown.sh)"
  only_if { File.exist?(node.jira.install) }
end


bash "delete-mysql-jira-database-and-user" do
  sql =<<EOS
DELETE FROM mysql.user WHERE user = 'jira';
DROP DATABASE jira;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  only_if { File.exist?("#{node.mysql.install_dir}/#{node.jira.mysql_db}") }
end


[node.jira.home, node.jira.install].each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end

file "/tmp/jira.tar.gz" do
  action :delete
end