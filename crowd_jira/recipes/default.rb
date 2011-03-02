#
# Cookbook Name:: crowd_jira
# Recipe:: default
#
# Copyright 2011, Example Com
#
require_recipe "crowd"
require_recipe "jira"

file "#{node.jira.install}/atlassian-jira/WEB-INF/lib/crowd-integration-client-2.0.7.jar" do
  action :delete
end

client_jar = "#{node.jira.install}/#{node.crowd_jira.client_jar}"
bash "copy-client-jar" do
  code "cp #{node.crowd.client_jar} #{client_jar}"
  not_if "test -f #{client_jar}"
end

ehcache_xml = "#{node.jira.install}/#{node.crowd_jira.ehcache_xml}"
bash "replace-ehcache-xml" do
  code "cp #{node.crowd.ehcache_xml} #{ehcache_xml}"
  not_if "test -f #{ehcache_xml}"
end

crowd_properties = "#{node.jira.install}/#{node.crowd_jira.properties}"
template "crowd-properties" do
  path = crowd_properties
  source "crowd.properties.erb"
  variables :name => "jira",
            :password => node.crowd_jira.password
end

file crowd_properties do
  mode "0644"
end

osuser_xml = "#{node.jira.install}/#{node.crowd_jira.osuser_xml}"
template "osuser-xml" do
  path = osuser_xml
  source "osuser.xml.erb"
end

file osuser_xml do
  mode "0644"
end

seraph_config_xml = "#{node.jira.install}/#{node.crowd_jira.seraph_config_xml}"
template "seraph-config-xml" do
  path = seraph_config_xml
  source "seraph-config.xml.erb"
end

file seraph_config_xml do
  mode "0644"
end
