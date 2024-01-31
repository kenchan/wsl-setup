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

package 'fisher' do
  notifies :run, 'execute[fish -c "fisher update"]'
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

DOTFILES_DIR = File.expand_path("../../../../dotfiles", __FILE__)

git 'kenchan/dotfiles' do
  user ENV['SUDO_USER']
  repository 'https://github.com/kenchan/dotfiles'
  destination DOTFILES_DIR
  revision 'master'
end

execute 'git switch master' do
  user ENV['SUDO_USER']
  command 'git switch master && git branch -d deploy'
  cwd DOTFILES_DIR
  only_if 'git branch --show-current | grep -q deploy'
end

execute 'run rcup' do
  user ENV['SUDO_USER']
  command "RCRC=#{DOTFILES_DIR}/rcrc rcup -f"
  not_if 'lsrc | grep -q dotfiles'
end


execute 'fish -c "fisher update"' do
  user ENV['SUDO_USER']
  action :nothing
end

puts <<-EOS
```
gh auth login
bin/mitamae local user.rb
```
EOS
