require_recipe 'apache2'

file node.apache2_proxy.conf do
  action :delete
end

ruby_block "exclude-proxy-conf" do
  block do
    inc = "Include conf/extra/httpd-proxy.conf"
    conf = File.read(node.apache2.conf)
    if conf.match(inc)
      File.open(node.apache2.conf, 'w') do |f|
        f.puts(conf.sub(inc, ""))
      end
    end
  end
end

bash "restart-apache" do
  code "#{node.apache2.apachectl} restart"
end