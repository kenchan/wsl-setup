include_recipe 'pacman.rb'
include_recipe '../locale/default.rb'
include_recipe '../sudoers/default.rb'

%w(
  base-devel
  bat
  consul-template
  direnv
  doggo
  duckdb
  fd
  ffmpeg
  fzf
  ghq
  git
  git-lfs
  github-cli
  gnupg
  imagemagick
  jpegoptim
  jq
  kubectl
  kubectx
  kubeseal
  less
  libyaml
  lsd
  mise
  neovim
  noto-fonts-cjk
  pngquant
  poppler
  ripgrep
  socat
  sshuttle
  starship
  stow
  strace
  subversion
  sudo
  unzip
  wget
  whois
  xdg-utils
  zip
).each do |pkg|
  package pkg
end

include_recipe 'paru.rb'
include_recipe 'gpg_keys.rb'
include_recipe 'aur_package_define.rb'

%w(
  1password-cli
  nkf
).each do |pkg|
  aur_package pkg
end

include_recipe 'docker.rb'
