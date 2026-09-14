%w(
  app-containers/docker
  app-containers/slirp4netns
  sys-apps/rootlesskit
).each do |pkg|
  package pkg
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

include_recipe '../docker/default.rb'
