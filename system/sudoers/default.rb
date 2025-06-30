directory '/etc/sudoers.d' do
  mode '0750'
  owner 'root'
  group 'root'
end

remote_file '/etc/sudoers.d/01-gentoo-emerge' do
  source 'files/etc/sudoers.d/01-gentoo-emerge'
  mode '0440'
  owner 'root'
  group 'root'
end

remote_file '/etc/sudoers.d/10-wheel-group' do
  source 'files/etc/sudoers.d/10-wheel-group'
  mode '0440'
  owner 'root'
  group 'root'
end