%w(
  autoconf
  bison
  build-essential
  curl
  gettext
  libcurl4-openssl-dev
  libedit-dev
  libffi-dev
  libgdbm-dev
  libgdbm6
  libicu-dev
  libjpeg-dev
  libmysqlclient-dev
  libncurses5-dev
  libonig-dev
  libpng-dev
  libpq-dev
  libreadline-dev
  libsqlite3-dev
  libssl-dev
  libxml2-dev
  libyaml-dev
  libzip-dev
  openssl
  pkg-config
  re2c
  zlib1g-dev
  libbz2-dev
).each do |pkg|
  package pkg do
    user "root"
  end
end

ASDF_INIT = "/bin/bash -c '. #{ENV['HOME']}/.asdf/asdf.sh;"

git 'install asdf' do
  repository 'https://github.com/asdf-vm/asdf.git'
  destination "#{ENV['HOME']}/.asdf"
  revision 'v0.9.0'
end

%w(
  ruby
  nodejs
  python
  rust
  terraform
  php
).each do |lang|
  execute "asdf plugin add #{lang}" do
    command "#{ASDF_INIT} asdf plugin add #{lang}'"
    not_if "#{ASDF_INIT} asdf plugin list | grep -q #{lang}'"
  end

  execute "asdf install #{lang} latest" do
    command "#{ASDF_INIT} asdf install #{lang} latest'"
    not_if "#{ASDF_INIT} asdf list #{lang} | grep -q \"\"'"
    # 何もインストールされていない場合、stdoutは空でstderrに出力がある
  end
end

execute 'install nodejs keyring' do
  command "bash #{ENV['HOME']}/.asdf/plugins/nodejs/bin/import-release-team-keyring"
  action :nothing
  subscribes :run, 'execute[asdf plugin add nodejs]', :immediately
end
