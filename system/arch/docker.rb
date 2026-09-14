include_recipe 'aur_package_define.rb'

%w(
  docker
  docker-buildx
  docker-compose
  rootlesskit
  slirp4netns
).each do |pkg|
  package pkg
end

# The official docker package omits dockerd-rootless.sh and its systemd user
# units; only the AUR carries them.
aur_package 'docker-rootless-extras'

include_recipe '../docker/default.rb'
