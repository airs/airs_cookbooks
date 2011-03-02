#
# Cookbook Name:: jira_plugins
# Recipe:: default
#
require_recipe "jira"

remote_file "upm" do
  path node.jira_plugins.upm.path
  source node.jira_plugins.upm.download_url
  not_if "test -f #{node.jira_plugins.upm.path}"
end

file node.jira_plugins.upm.path do
  mode "0644"
end