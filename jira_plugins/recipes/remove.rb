require_recipe "jira"

file node.jira_plugins.upm.path do
  action :delete
end

bash "restart-jira" do
  code "(cd #{node.jira.install}/bin; ./shutdown.sh; ./startup.sh)"
end
