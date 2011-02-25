package "zsh" do
  action :remove
end

bash "remove-zshrc" do
  code "rm #{ENV['HOME']}/.zshrc"
end
