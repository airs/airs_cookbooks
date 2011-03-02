#
# Cookbook Name:: crowd_confluence
# Recipe:: default
#
require_recipe "crowd"
require_recipe "confluence"

client_jar = "#{node.confluence.install}/#{node.crowd_confluence.client_jar}"
bash "copy-client-jar" do
  code "cp #{node.crowd.client_jar} #{client_jar}"
  not_if "test -f #{client_jar}"
end

crowd_properties = "#{node.confluence.install}/#{node.crowd_confluence.properties}"
template crowd_properties do
  source "crowd.properties.erb"
  variables :name => "confluence",
            :password => node.crowd_confluence.password
end

file crowd_properties do
  mode "0644"
end

ehcache_xml = "#{node.confluence.install}/#{node.crowd_confluence.ehcache_xml}"
bash "replace-ehcache-xml" do
  code "cp #{node.crowd.ehcache_xml} #{ehcache_xml}"
end

atlassian_user_xml = "#{node.confluence.install}/#{node.crowd_confluence.atlassian_user_xml}"
template atlassian_user_xml do
  source "atlassian-user.xml.erb"
end

file atlassian_user_xml do
  mode "0644"
end

seraph_config_xml = "#{node.confluence.install}/#{node.crowd_confluence.seraph_config_xml}"
template seraph_config_xml do
  source "seraph-config.xml.erb"
end

file seraph_config_xml do
  mode "0644"
end
