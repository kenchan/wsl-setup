execute 'frgm init' do
  user ENV['SUDO_USER']
  not_if "test -e /home/#{ENV['SUDO_USER']}/.config/frgm/config.toml"
end

execute 'yes | frgm repo add https://github.com/kenchan/snippets.git' do
  user ENV['SUDO_USER']
  not_if "test -d /home/#{ENV['SUDO_USER']}/.local/share/frgm/snippets/github.com__kenchan__snippets"
end
