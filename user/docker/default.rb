if node[:platform] == 'gentoo'
  # A hand-written unit under ~/.config shadows the managed one, and its
  # enablement symlink still points there once it is gone, so is-enabled keeps
  # reporting success and nothing would pick up the replacement.
  file "#{ENV['HOME']}/.config/systemd/user/docker.service" do
    action :delete
    only_if "grep -q dockerd-rootless #{ENV['HOME']}/.config/systemd/user/docker.service"
    notifies :run, 'execute[switch to the managed docker user service]', :immediately
  end

  execute 'switch to the managed docker user service' do
    command <<-EOS
      systemctl --user daemon-reload &&
      systemctl --user reenable docker.service &&
      systemctl --user restart docker.service
    EOS
    action :nothing
  end

  execute 'enable the rootless docker user service' do
    command 'systemctl --user enable --now docker.service'
    not_if 'systemctl --user -q is-enabled docker.service'
  end

  # The rootless socket lives under XDG_RUNTIME_DIR, which the CLI does not
  # probe on its own.
  execute 'docker context create rootless' do
    command 'docker context create rootless --docker "host=unix:///run/user/$(id -u)/docker.sock"'
    not_if 'docker context inspect rootless > /dev/null 2>&1'
  end

  execute 'docker context use rootless' do
    not_if 'docker context show | grep -qx rootless'
  end
end
