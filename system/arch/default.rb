include_recipe 'paru.rb'
include_recipe 'gpg_keys.rb'
include_recipe 'pacman.rb'
include_recipe '../locale/default.rb'

%w(
  1password-cli
  base-devel
  bat
  consul-template
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

include_recipe '../docker/default.rb'
