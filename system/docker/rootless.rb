DOCKER_USER = ENV['SUDO_USER']

%w(
  app-containers/docker
  app-containers/slirp4netns
  sys-apps/rootlesskit
  sys-fs/fuse-overlayfs
).each do |pkg|
  package pkg
end

# Portage ships dockerd-rootless.sh but none of the systemd user units for it.
directory '/etc/systemd/user'

%w(docker.service docker.socket).each do |unit|
  remote_file "/etc/systemd/user/#{unit}" do
    source "files/etc/systemd/user/#{unit}"
    mode '644'
    owner 'root'
    group 'root'
  end
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
