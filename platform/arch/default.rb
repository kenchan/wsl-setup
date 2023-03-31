include_recipe '../../cookbooks/locale/default.rb'

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
  docker-buildx
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
  git-lfs
  github-cli
  sshuttle
  bat
  fd
  lsd
  ripgrep
  sd
  peco
  stow
  zip
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

define :aur_package do
  execute "paru -S -a --noconfirm #{params[:name]}" do
    user ENV['SUDO_USER']
    not_if "pacman -Qm | grep -q #{params[:name]}"
  end
end

execute 'gpg --receive-keys 3FEF9748469ADBE15DA7CA80AC2D62742012EA22' do
  user ENV['SUDO_USER']
  not_if 'gpg -k | grep -q 3FEF9748469ADBE15DA7CA80AC2D62742012EA22'
end

%w(
  1password-cli
  ghq
  google-cloud-cli
  rcm
  rtx
  win32yank-bin
  nkf
).each do |pkg|
  aur_package pkg
end

file '/etc/pacman.conf' do
  action :edit
  block do |content|
    content.gsub!(/^#Color/, "Color")
  end
end

