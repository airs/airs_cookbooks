#
# Cookbook Name:: crowd_bamboo
# Recipe:: default
#
require_recipe "crowd"
require_recipe "bamboo"

file "#{node.bamboo.install}/webapp/WEB-INF/lib/crowd-integration-client-2.0.7.jar" do
  action :delete
end

client_jar = "#{node.bamboo.install}#{node.crowd_bamboo.client_jar}"
bash "copy-client-jar" do
  code "cp #{node.crowd.client_jar} #{client_jar}"
  not_if "test -f #{client_jar}"
end

crowd_properties = "#{node.bamboo.install}#{node.crowd_bamboo.properties}"
template crowd_properties do
  source "crowd.properties.erb"
  variables :name => "bamboo",
            :password => node.crowd_bamboo.password
end

file crowd_properties do
  mode "0644"
end

ehcache_xml = "#{node.bamboo.install}#{node.crowd_bamboo.ehcache_xml}"
bash "replace-ehcache-xml" do
  code "cp #{node.crowd.ehcache_xml} #{ehcache_xml}"
end

atlassian_user_xml = "#{node.bamboo.install}#{node.crowd_bamboo.atlassian_user_xml}"
template atlassian_user_xml do
  source "atlassian-user.xml.erb"
end

file atlassian_user_xml do
  mode "0644"
end

seraph_config_xml = "#{node.bamboo.install}#{node.crowd_bamboo.seraph_config_xml}"
template seraph_config_xml do
  source "seraph-config.xml.erb"
end

file seraph_config_xml do
  mode "0644"
end
