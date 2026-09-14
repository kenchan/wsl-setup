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

# The WSL image was unpacked without xattrs, so everything shadow ships lost its
# file capabilities and rootlesskit cannot map the subordinate ids. Packages
# installed by pacman afterwards keep theirs, so only the image needs repairing.
{
  '/usr/bin/newuidmap' => 'cap_setuid+ep',
  '/usr/bin/newgidmap' => 'cap_setgid+ep',
}.each do |path, capability|
  execute "setcap #{capability} #{path}" do
    not_if "getcap #{path} | grep -q cap_"
  end
end

include_recipe '../docker/default.rb'
