execute "import gcloud gpg key" do
  user "root"
  command "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -"
  not_if "apt-key list | grep gc-team@google.com"
end

execute "add kubectl apt repository" do
  user "root"
  command 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list'
  not_if "test -e /etc/apt/sources.list.d/kubernetes.list"
end

packages = %w(
  tmux
  peco
  kubectl
).each do |pkg|
  package pkg do
    user "root"
  end
end

directory "#{ENV['HOME']}/bin"

git 'https://github.com/starship/starship' do
  repository 'https://github.com/starship/starship'
  destination "#{ENV['HOME']}/src/github.com/starship/starship"
end

execute 'install starship' do
  command "install/install.sh -y -b #{ENV['HOME']}/bin"
  cwd "#{ENV['HOME']}/src/github.com/starship/starship"
  subscribes :run, 'git[https://github.com/starship/starship]'
  action :nothing
end
