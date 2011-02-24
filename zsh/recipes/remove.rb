package "zsh" do
  action :remove
end

bash "remove-zshrc" do
  code "rm #{node.home}/.zshrc"
end
