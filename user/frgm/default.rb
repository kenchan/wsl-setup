execute 'frgm init' do
  not_if "test -e ~/.config/frgm/config.toml"
end

execute 'yes | frgm repo add https://github.com/kenchan/snippets.git' do
  not_if "test -d ~/.local/share/frgm/snippets/github.com__kenchan__snippets"
end
