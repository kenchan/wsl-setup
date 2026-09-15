directory '/etc/sudoers.d' do
  mode '0750'
  owner 'root'
  group 'root'
end

remote_file '/etc/sudoers.d/00-wheel-group' do
  source 'files/etc/sudoers.d/00-wheel-group'
  mode '0440'
  owner 'root'
  group 'root'
end

case node[:platform]
when 'gentoo'
  remote_file '/etc/sudoers.d/10-gentoo-emerge' do
    source 'files/etc/sudoers.d/10-gentoo-emerge'
    mode '0440'
    owner 'root'
    group 'root'
  end
when 'arch'
  # paru shells out to pacman, and provisioning has no tty to prompt on.
  remote_file '/etc/sudoers.d/10-arch-pacman' do
    source 'files/etc/sudoers.d/10-arch-pacman'
    mode '0440'
    owner 'root'
    group 'root'
  end
end
