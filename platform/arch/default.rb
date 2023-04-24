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
  consul-template
  vault
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
  not_if 'command -v paru > /dev/null'
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
  kagiana
  frgm
).each do |pkg|
  aur_package pkg
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

include_recipe '../../cookbooks/ssh/default.rb'

package 'fish'

package 'fisher' do
  notifies :run, 'execute[fish -c "fisher update"]'
end

execute 'fish -c "fisher update"' do
  user ENV['SUDO_USER']
  action :nothing
end

# wslu
execute 'pacman-key -r A2861ABFD897DD37 && pacman-key --lsign-key A2861ABFD897DD37' do
  not_if 'pacman-key --list-keys | grep -q A2861ABFD897DD37'
end

file '/etc/pacman.conf' do
  action :edit
  block do |content|
    unless content =~ /\[wslutilities\]/
      content << <<EOS
[wslutilities]
Server = https://pkg.wslutiliti.es/arch/
EOS
    end
  end

  notifies :run, 'execute[pacman -Sy]', :immediately
end

execute 'pacman -Sy' do
  action :nothing
end

package 'wslu'

puts <<-EOS
```
gh auth login
bin/mitamae local user.rb
```
EOS
