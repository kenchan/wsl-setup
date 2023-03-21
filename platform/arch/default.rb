node.reverse_merge({
  user: ENV['SUDO_USER']
})

# base-develはインストールがうまくいかない
%w(
  base-devel
  git
  neovim
  wget
  unzip
).each do |pkg|
  package pkg
end

%w(
  docker
  docker-compose
  kubectl
  kubectx
).each do |pkg|
  package pkg
end

service 'docker' do
  action [:enable, :start]
end

execute "gpasswd -a #{ENV['SUDO_USER']} docker" do
  not_if "groups #{ENV['SUDO_USER']} | grep -q docker"
end

%w(
  jq
  tmux
  fish
  fisher
  starship
  git-delta
  github-cli
  sshuttle
  bat
  fd
  lsd
  ripgrep
  sd
  peco
  stow
).each do |pkg|
  package pkg
end

%w(
  rust
  ruby
).each do |pkg|
  package pkg
end

git 'https://aur.archlinux.org/paru.git' do
  user ENV['SUDO_USER']
  destination '/tmp/paru'
  repository 'https://aur.archlinux.org/paru.git'
end

execute 'makepkg -si --noconfirm' do
  user ENV['SUDO_USER']
  cwd '/tmp/paru'
  not_if 'command -v paru > /dev/null'
end
