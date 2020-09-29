execute 'apt-get update' do
  user 'root'
end

execute 'apt-get upgrade -y' do
  user 'root'
end

execute "import gcloud gpg key" do
  user "root"
  command "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key add -"
  not_if "apt-key list | grep gc-team@google.com"
end

execute "add kubectl apt repository" do
  user "root"
  command 'echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list'
  not_if "test -e /etc/apt/sources.list.d/kubernetes.list"
  notifies :run, 'execute[apt-get update]'
end

execute "import thoutbot's gpg key" do
  user "root"
  command "wget -qO - https://apt.thoughtbot.com/thoughtbot.gpg.key | sudo apt-key add -"
  not_if "apt-key list | grep thoughtbot"
end

execute "add thoutbot's apt repository" do
  user "root"
  command "echo 'deb https://apt.thoughtbot.com/debian/ stable main' | tee /etc/apt/sources.list.d/thoughtbot.list"
  not_if "test -e /etc/apt/sources.list.d/thoughtbot.list"
  notifies :run, 'execute[apt-get update]'
end

execute "import github cli's gpg key" do
  user "root"
  command "apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0"
  not_if "apt-key list | grep -E -q '^uid(.*)@github.com'"
end

execute "add github cli's apt repository" do
  user "root"
  command "sudo apt-add-repository https://cli.github.com/packages"
  not_if "apt-cache policy | grep -q 'cli.github.com'"
  notifies :run, 'execute[apt-get update]'
end
