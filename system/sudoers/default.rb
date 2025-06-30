remote_file '/etc/sudoers.d/01-wheel-group' do
  source 'files/etc/sudoers.d/01-wheel-group'
  mode '0440'
  owner 'root'
  group 'root'
end

remote_file '/etc/sudoers.d/10-gentoo-emerge' do
  source 'files/etc/sudoers.d/10-gentoo-emerge'
  mode '0440'
  owner 'root'
  group 'root'
end