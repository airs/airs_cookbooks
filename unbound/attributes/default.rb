default[:unbound][:conf] = "/opt/local/etc/unbound/unbound.conf"
default[:unbound][:pid] = "/opt/local/etc/unbound/unbound.pid"
default[:unbound][:interface] = "192.168.0.1"
default[:unbound][:access_control] = "192.168.0.0/24 allow"
default[:unbound][:local_data_list] = [ "foo.example.com A 192.168.0.1" ]