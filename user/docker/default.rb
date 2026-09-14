UNIT = "#{ENV['HOME']}/.config/systemd/user/docker.service"

directory "#{ENV['HOME']}/.config/systemd"
directory "#{ENV['HOME']}/.config/systemd/user"

# Portage ships dockerd-rootless.sh but no unit for it, and letting
# dockerd-rootless-setuptool.sh generate one bakes in the PATH it was run with.
remote_file UNIT do
  source 'files/systemd/user/docker.service'
  mode '644'
  notifies :run, 'execute[reload and restart the docker user service]', :immediately
end

execute 'reload and restart the docker user service' do
  command <<-EOS
    systemctl --user daemon-reload &&
    systemctl --user reenable docker.service &&
    systemctl --user restart docker.service
  EOS
  action :nothing
end

execute 'enable the rootless docker user service' do
  command 'systemctl --user enable --now docker.service'
  # A failed start leaves the service enabled but stopped.
  not_if 'systemctl --user -q is-enabled docker.service && systemctl --user -q is-active docker.service'
end

# The CLI does not probe XDG_RUNTIME_DIR for the rootless socket.
execute 'docker context create rootless' do
  command 'docker context create rootless --docker "host=unix:///run/user/$(id -u)/docker.sock"'
  not_if 'docker context inspect rootless > /dev/null 2>&1'
end

execute 'docker context use rootless' do
  not_if 'docker context show | grep -qx rootless'
end
