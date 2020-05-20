%w(
  autoconf
  bison
  build-essential
  libffi-dev
  libgdbm-dev
  libgdbm6
  libncurses5-dev
  libreadline-dev
  libssl-dev
  libyaml-dev
  zlib1g-dev
).each do |pkg|
  package pkg do
    user "root"
  end
end

ASDF_INIT = "/bin/bash -c '. #{ENV['HOME']}/.asdf/asdf.sh;"

git 'install asdf' do
  repository 'https://github.com/asdf-vm/asdf.git'
  destination "#{ENV['HOME']}/.asdf"
  revision 'v0.7.8'
end

%w(
  ruby
  nodejs
  python
  rust
  terraform
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
