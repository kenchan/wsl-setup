packages = %w(
  rcm
  fish
  tmux
  peco
).each do |pkg|
  package pkg do
    user "root"
    action :install
  end
end

# ruby-build requirements
%w(
  autoconf
  bison
  build-essential
  libssl-dev
  libyaml-dev
  libreadline6-dev
  zlib1g-dev
  libncurses5-dev
  libffi-dev
  libgdbm5
  libgdbm-dev
).each do |pkg|
  package pkg do
    user "root"
    action :install
  end
end
