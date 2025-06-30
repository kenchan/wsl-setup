remote_file '/etc/sudoers.d/gentoo-emerge' do
  source 'files/etc/sudoers.d/gentoo-emerge'
  mode '0440'
  owner 'root'
  group 'root'
end