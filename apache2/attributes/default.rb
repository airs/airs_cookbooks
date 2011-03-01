default[:apache2][:base] = "/opt/local/apache2"
default[:apache2][:conf] = "#{default[:apache2][:base]}/conf/httpd.conf"
default[:apache2][:apachectl] = "#{default[:apache2][:base]}/bin/apachectl"