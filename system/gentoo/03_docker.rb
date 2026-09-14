DOCKER_USER = ENV['SUDO_USER']

%w(
  app-containers/docker
  app-containers/slirp4netns
  sys-apps/rootlesskit
).each do |pkg|
  package pkg
end

# The rootful daemon modprobes what it needs; a user service cannot.
remote_file '/etc/modules-load.d/docker.conf' do
  source 'files/etc/modules-load.d/docker.conf'
  mode '644'
  owner 'root'
  group 'root'
  notifies :run, 'execute[systemctl restart systemd-modules-load]'
end

execute 'systemctl restart systemd-modules-load' do
  action :nothing
end

# An existing range is left alone: rewriting it would orphan everything already
# stored under ~/.local/share/docker.
execute 'reserve subordinate ids for rootless docker' do
  command "usermod --add-subuids 100000-165535 --add-subgids 100000-165535 #{DOCKER_USER}"
  not_if "grep -q '^#{DOCKER_USER}:' /etc/subuid && grep -q '^#{DOCKER_USER}:' /etc/subgid"
end

execute 'disable the system-wide docker daemon' do
  command 'systemctl disable --now docker.socket docker.service'
  only_if 'systemctl is-enabled docker.socket docker.service 2>/dev/null | grep -q "^enabled"'
end

execute "loginctl enable-linger #{DOCKER_USER}" do
  not_if "loginctl show-user #{DOCKER_USER} --property=Linger | grep -q yes"
end
