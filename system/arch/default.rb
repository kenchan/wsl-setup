include_recipe 'paru.rb'
include_recipe '../locale/default.rb'

# 1password
execute 'gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22' do
  user ENV['SUDO_USER']
  not_if 'gpg -k | grep -q 3FEF9748469ADBE15DA7CA80AC2D62742012EA22'
end

%w(
  1password-cli
  base-devel
  bat
  consul-template
  docker
  docker-buildx
  docker-compose
  fd
  fish
  fisher
  frgm
  ghq-bin
  git
  git-delta
  git-lfs
  github-cli
  google-cloud-cli
  jq
  kagiana
  kubectl
  kubectx
  less
  lsd
  man
  mise-bin
  neovim
  peco
  rcm
  ripgrep
  sd
  socat
  sshuttle
  starship
  stow
  tailspin
  tmux
  unzip
  vault
  wget
  win32yank-bin
  zip
).each do |pkg|
  package pkg
end

service 'docker' do
  action [:enable, :start]
end

execute "gpasswd -a #{ENV['SUDO_USER']} docker" do
  not_if "groups #{ENV['SUDO_USER']} | grep -q docker"
end

file '/etc/pacman.conf' do
  action :edit
  block do |content|
    content.gsub!(/^#Color/, "Color")
  end
end

puts <<-EOS
```
$ gh auth login
$ bin/mitamae local user.rb
```
EOS
