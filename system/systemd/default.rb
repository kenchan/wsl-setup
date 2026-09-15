directory '/etc/systemd/resolved.conf.d' do
  owner 'root'
  group 'root'
  mode '755'
  action :create
end

remote_file '/etc/systemd/resolved.conf.d/dns_servers.conf' do
  owner 'root'
  group 'root'
  mode '644'
  source 'files/etc/systemd/resolved.conf.d/dns_servers.conf'
end

execute 'enable and start systemd-resolved' do
  command 'systemctl enable systemd-resolved && systemctl start systemd-resolved'
  not_if 'systemctl is-active systemd-resolved'
end

execute 'mask systemd-firstboot' do
  command 'systemctl mask systemd-firstboot'
  not_if 'systemctl is-enabled systemd-firstboot | grep masked'
end

execute 'disable and stop systemd-networkd-wait-online' do
  command 'systemctl disable systemd-networkd-wait-online && systemctl stop systemd-networkd-wait-online'
  only_if 'systemctl is-enabled systemd-networkd-wait-online'
end

# Any file here lets systemd-binfmt.service run, and WSL's drop-in on that unit
# re-registers WSLInterop. Terminating another systemd distro wipes it:
# https://github.com/microsoft/WSL/issues/13885
remote_file '/etc/binfmt.d/WSLInterop.conf' do
  source 'files/etc/binfmt.d/WSLInterop.conf'
  owner 'root'
  group 'root'
  mode '644'
  notifies :run, 'execute[systemctl restart systemd-binfmt]'
end

execute 'systemctl restart systemd-binfmt' do
  action :nothing
end
