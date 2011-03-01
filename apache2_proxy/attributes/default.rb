default[:apache2_proxy][:conf] = "/opt/local/apache2/conf/extra/httpd-proxy.conf"
default[:apache2_proxy][:mapping] = {
  "/crowd" => "http://localhost:8095/crowd",
  "/jira" => "http://localhost:8080/jira",
  "/confluence" => "http://localhost:8090/confluence",
  "/fisheye" => "http://localhost:8060/fisheye",
  "/bamboo" => "http://localhost:8085/bamboo"
}