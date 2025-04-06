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