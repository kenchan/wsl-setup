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