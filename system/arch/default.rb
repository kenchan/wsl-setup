include_recipe 'pacman.rb'
include_recipe '../locale/default.rb'
include_recipe '../sudoers/default.rb'
include_recipe 'paru.rb'
include_recipe 'gpg_keys.rb'
include_recipe 'aur_package_define.rb'

%w(
  base-devel
  bat
  consul-template
  direnv
  doggo
  duckdb
  fd
  ffmpeg
  fish
  fzf
  ghq
  git
  git-delta
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
  man-db
  mise
  neovim
  noto-fonts-cjk
  peco
  pngquant
  poppler
  ripgrep
  sd
  socat
  sshuttle
  starship
  stow
  strace
  subversion
  sudo
  tailspin
  tmux
  unzip
  vault
  wget
  whois
  xdg-utils
  zip
).each do |pkg|
  package pkg
end

%w(
  1password-cli
  frgm
  google-cloud-cli
  kagiana
  nkf
  win32yank-bin
).each do |pkg|
  aur_package pkg
end

include_recipe 'docker.rb'
