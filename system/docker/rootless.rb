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

# Portage ships dockerd-rootless.sh but not the systemd user unit that
# dockerd-rootless-setuptool.sh would generate.
directory '/etc/systemd/user'

remote_file '/etc/systemd/user/docker.service' do
  source 'files/etc/systemd/user/docker.service'
  mode '644'
  owner 'root'
  group 'root'
end

# An existing range is left alone: rewriting it would orphan everything already
# stored under ~/.local/share/docker.
execute 'reserve subordinate ids for rootless docker' do
  command "usermod --add-subuids 100000-165535 --add-subgids 100000-165535 #{DOCKER_USER}"
  not_if "grep -q '^#{DOCKER_USER}:' /etc/subuid && grep -q '^#{DOCKER_USER}:' /etc/subgid"
end

# A system-wide daemon would compete with the rootless one for images and sockets.
execute 'disable the system-wide docker daemon' do
  command 'systemctl disable --now docker.socket docker.service'
  only_if 'systemctl is-enabled docker.socket docker.service 2>/dev/null | grep -q "^enabled"'
end

# The daemon is a systemd user service, so it must keep running without a login.
execute "loginctl enable-linger #{DOCKER_USER}" do
  not_if "loginctl show-user #{DOCKER_USER} --property=Linger | grep -q yes"
end
