bash "stop-crowd" do
  code "(cd #{node.crowd.install}; ./stop_crowd.sh)"
end

bash "delete-mysql-crowd-database-and-user" do
  sql =<<EOS
DELETE FROM mysql.user WHERE user = 'crowd';
DROP DATABASE crowd;
EOS
  code %(#{node.mysql.mysql} -u root -p"#{node.mysql.root_password}" -e"#{sql}")
  only_if "test -f #{node.crowd.install}"
end

[node.crowd.home, node.crowd.install].each do |dir|
  directory dir do
    recursive true
    action :delete
  end
end

file "/tmp/crowd.tar.gz" do
  action :delete
end
